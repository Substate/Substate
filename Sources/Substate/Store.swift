import Foundation
import Runtime

public class Store: ObservableObject {

    // TODO: Since we’re dogfooding our own state management system here right in the store,
    // is there any API we’d like to expose? Some actions on the store?
    struct InternalModel: Model {
        var middlewareModels: [Model]
        var appModel: Model
        func update(action: Action) {}
    }
    
    // No point in this being public since underlying type isn’t available
    // Need to use select(state:), and make that more ergonomic
    // Don’t really need this to be published, can handle the single objectWillChange() call manually?
    @Published private var model: InternalModel
    private let middleware: [Middleware]
    private var updateFunction: Update!

    // TODO: Provide a publisher/AsyncSequence for easy subscription to model changes

    public init(model: Model, middleware: [Middleware] = []) {
        self.model = InternalModel(
            middlewareModels: middleware.compactMap(\.model),
            appModel: model
        )

        self.middleware = middleware

        self.updateFunction = self.middleware
            .reversed()
            .reduce({ action in
                self.performUpdate(action: action)
            }, { update, middleware in
                return middleware.update(store: self)(update)
            })

        self.middleware.forEach { $0.setup(store: self) }
        // TODO: Build up a list of substate type -> path segment mappings
        // Then at runtime use Mirror.descendant(a, b, c) to grab the value, rather than iterating every time
    }

    public func update(_ action: Action) {
        precondition(Thread.isMainThread, "Update must be called on the main thread!")
        updateFunction(action)
    }

    private func performUpdate(action: Action) {
        precondition(Thread.isMainThread, "Update must be called on the main thread!")
        model = reduce(model: model, action: action)
    }

    // NOTE: This will always have to be optional. But using a view helper in the same way as
    // ConnectedView, we can give child ConnectedViews a non-optional `state` property.
    // If the required state isn’t found, we could just show an empty view instead as a failure
    // mode (and log the error!)
    public func find<ModelType:Model>(_ type: ModelType.Type) -> ModelType? {
        // TODO: Don’t do this search every time, cache in init!
        flatten(object: model).first(where: { $0 is ModelType }) as? ModelType
    }

    // TODO: Better naming
    public var rootModel: Model {
        model.appModel
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

                // Try and mutate the member

                let reducedChildValue = reduce(model: childValue, action: action)

                if var model = model as? [Model] {
                    // Child is a collection member; set by index
                    model[index] = reducedChildValue
                } else {
                    // Child is a property; set by mirror label
                    let info = try! typeInfo(of: type(of: model as Any))
                    let property = try! info.property(named: child.label!)
                    try! property.set(value: reducedChildValue, on: &model)
                }
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
