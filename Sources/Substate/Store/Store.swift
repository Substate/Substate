import Foundation
import Runtime

/// Stores all models and allows them to be mutated by actions.
///
public final class Store: ObservableObject {

    private var models: [Model] = []
    private var modelKeyPaths: [DynamicKeyPath<Model>] = []

    private let middleware: [Middleware]
    private var dispatchFunction: Send!

    /// Create a store with a primary model, and any required middleware.
    ///
    public init(model: Model, middleware: [Middleware] = []) {
        self.middleware = middleware

        models.append(model)
        updateModelKeyPaths()

        dispatchFunction = self.middleware
            .reversed()
            .reduce({ [weak self] in self?.update(action: $0) }, { update, middleware in
                let weakSend: Send = { [weak self] in self?.send($0) }
                let weakFind: Find = { [weak self] in self?.uncheckedFind($0) ?? [] }

                return middleware.update(send: weakSend, find: weakFind)(update)
            })

        send(Start())
    }

    // MARK: - Action Dispatch

    public func send(_ action: Action) {
        precondition(Thread.isMainThread, "Update must be called on the main thread!") // TODO: Remove, rely on @MainActor

        if isUpdating {
            queue.append(action)
            return
        }

        isUpdating = true
        dispatchFunction(action)
        isUpdating = false

        if !queue.isEmpty {
            self.send(queue.removeFirst())
        }
    }

    private var isUpdating = false
    private var queue: [Action] = []

    private func update(action: Action) {
        precondition(Thread.isMainThread, "Update must be called on the main thread!") // TODO: Remove, rely on @MainActor
        objectWillChange.send()

        if let register = action as? Register {
            models.append(register.model)
            updateModelKeyPaths()
        }

        for property in modelKeyPaths {
            var value = property.get(on: models)!

            if let replace = action as? Store.Replace {
                if type(of: replace.model) == type(of: value) {
                    value = replace.model
                }
            }

            value.update(action: action)
            try! property.set(to: value, on: &models)
        }
    }

    // MARK: - Model Retrieval

    // TODO: Try and improve and simplify the find methods on offer here.

    public func find<ModelType:Model>(_ type: ModelType.Type) -> ModelType? {
        return modelKeyPaths
            .first(where: { $0.type == ModelType.self })?
            .get(on: models) as? ModelType
    }

    public func uncheckedFind(_ modelType: Model.Type? = nil) -> [Model] {
        if let modelType = modelType {
            return modelKeyPaths
                .filter { $0.type == modelType }
                .compactMap { $0.get(on: models) }
        } else {
            return modelKeyPaths
                .compactMap { $0.get(on: models) }
        }
    }

    //

    private func updateModelKeyPaths() {
        modelKeyPaths = DynamicKeyPath<Model>
            .all(on: models)
            .sorted { $0.path.count > $1.path.count }
    }

}
