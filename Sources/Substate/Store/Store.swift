import Foundation
import Runtime

/// Stores all models and allows them to be mutated by actions.
///
/// TODO: Integrate the 'walker' (renamed!) into the store
/// - cache the structure ('paths') of all models upfront; and when registering new ones
/// - on send action, iterate through all paths and run the update (without walking the entire state tree)
/// - optimise the find function since it can just query the cached paths and go straight to a matching one
///   should work for both find functions
/// - maybe store this whole damn info in the 'model'
/// - implement 'replace' as a special case that only visits the relevant path (if found)
///   - can still send action after so client models can see it
///   - find out if we can do this with a generic so you can catch `Store.Replace<MyModel>`
/// - do the same with register, we have custom behaviour there too.
///
/// - On second thoughts, with both replace and register why don’t we dogfood our own system and
///   catch them within our internal model? Including caching?
///   - And also for the initial model load in?
///
public class Store: ObservableObject {

    // TODO: Put any other previously-special-cased operations into this model as official store
    // actions, and keep the `reduce` function completely clean so all it does is walk the tree.
    private struct InternalModel: Model {
        var staticModel: Model
        var dynamicModels: [Model] = []

        mutating func update(action: Action) {
            if let register = action as? Register {
                dynamicModels.append(register.model)
            }
        }
    }

    // Don’t really need this to be published, can handle the single objectWillChange() call manually?
    @Published private var model: InternalModel
    private let middleware: [Middleware]
    private var updateFunction: Send!

    // TODO: Provide a publisher/AsyncSequence for easy subscription to model changes

    /// Create a store with an initial root model, and any required middleware.
    ///
    public init(model: Model, middleware: [Middleware] = []) {
        self.model = InternalModel(staticModel: model)

        self.middleware = middleware

        self.updateFunction = self.middleware
            .reversed()
            .reduce({ [weak self] in self?.performSend(action: $0) }, { update, middleware in
                let weakSend: Send = { [weak self] in self?.send($0) }
                let weakFind: Find = { [weak self] in self?.uncheckedFind($0) ?? [] }

                return middleware.update(send: weakSend, find: weakFind)(update)
            })

        DispatchQueue.main.async {
            self.send(Start())
        }

        // TODO: Build up a list of substate type -> path segment mappings
        // Then at runtime use Mirror.descendant(a, b, c) to grab the value, rather than iterating every time
    }

    public func send(_ action: Action) {
        precondition(Thread.isMainThread, "Update must be called on the main thread!")
        if isUpdating {
            queue.append(action)
            return
        }

        // This is kind of basic but it works given we’re requiring calling update on the
        // main thread. Should we be using an atomic instead of a Bool to avoid deadlocks?
        // Is there a more elegant factoring of this lock/queue routine?
        isUpdating = true
        updateFunction(action)
        isUpdating = false

        if !queue.isEmpty {
            self.send(queue.removeFirst())
        }
    }

    var isUpdating = false
    var queue: [Action] = []

    private func performSend(action: Action) {
        precondition(Thread.isMainThread, "Update must be called on the main thread!")
        model = reduce(model: model, action: action)
    }

    // NOTE: This will always have to be optional. But using a view helper in the same way as
    // ConnectedView, we can give child ConnectedViews a non-optional `state` property.
    // If the required state isn’t found, we could just show an empty view instead as a failure
    // mode (and log the error!)
    public func find<ModelType:Model>(_ type: ModelType.Type) -> ModelType? {
        // TODO: Don’t do this search every time, cache in init!
        return flatten(object: model).first(where: { $0 is ModelType }) as? ModelType
    }

    public func uncheckedFind(_ modelType: Model.Type? = nil) -> [Model] {
        // Is there some way to avoid needing this version of find?
        // In cases where we don’t have the model type statically, can we still somehow
        // call the generic find<>?
        if let modelType = modelType {
            return flatten(object: model).filter { type(of: $0) == modelType }.compactMap { $0 as? Model }
        } else {
            return flatten(object: model).compactMap { $0 as? Model }
        }
    }

    // TODO: Better naming
    public var rootModel: Model {
        model.staticModel
    }

    // TODO: Better naming
    // TODO: Optimise, bigtime!
    public var allModels: [Model] {
        flatten(object: self.model).compactMap { $0 as? Model }
    }

    private func flatten(object: Any) -> [Any] {
        let mirror = Mirror(reflecting: object)
        return [object] + mirror.children.map(\.value).flatMap(flatten(object:))
    }

    /// TODO: Clean this up, remove dependency on Runtime library
    private func reduce<ModelType>(model: ModelType, action: Action) -> ModelType {
        // TODO: Don’t do this search every time, cache in init!
        var model = model

        // TODO: This isn’t actually recursive yet! Only recurses through `Model` children.
        // TODO: Factor out this helper, it’s complex and needs its own tests.

        let mirror = Mirror(reflecting: model)

        for (index, child) in mirror.children.enumerated() {
            if let childValue = child.value as? Model {

                var replacedChildValue = childValue

                // Try and mutate the member

                // First action any Replace action on this model
                if let action = action as? Store.Replace {
                    let newModel = action.model
                    if type(of: newModel) == type(of: childValue) {
                        replacedChildValue = newModel
                    }
                }

                // Then follow reduce as usual, to ensure Replace is actioned on any relevant children
                let reducedChildValue = reduce(model: replacedChildValue, action: action)

                if var m1 = model as? [Model] {
                    // Child is a collection member; set by index
                    m1[index] = reducedChildValue
                    if let m2 = m1 as? ModelType {
                        model = m2
                    }
                } else {
                    // Child is a property; set by mirror label
                    let info = try! typeInfo(of: type(of: model as Any))
                    let property = try! info.property(named: child.label!)
                    try! property.set(value: reducedChildValue, on: &model)
                }
            } else if let _ = child.value as? [Model] {
                // TODO: There’s a major issue here in that we don’t handle arrays properly!
            }
        }

        if var s = model as? Model {
            s.update(action: action)
            if let s1 = s as? ModelType {
                model = s1
            }
        }

        return model
    }

}
