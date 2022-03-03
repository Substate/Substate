import Foundation

/// Stores all models and allows them to be mutated by actions.
///
@MainActor public final class Store: ObservableObject {

    private var models: [Model] = []
    private var modelKeyPaths: [DynamicKeyPath<Model>] = []

    private lazy var _dispatch: DispatchFunction = reduce

    /// Create a store with a primary model, and any required middleware.
    ///
    public init(model: Model, middleware: [Middleware] = []) {
        addModel(model: model)

        for middleware in middleware.reversed() {
            _dispatch = middleware.configure(store: self)(_dispatch)
        }

        // TODO: How does anything wait on any results of this dispatch (eg. for testing middleware
        // that responds to this action)?

        dispatch(Start())
    }

    // MARK: - Actions

    /// Dispatch an action and ignore its execution and any errors.
    ///
    public func dispatch(_ action: Action)  {
        Task { try await dispatch(action) }
    }

    /// Dispatch an action and wait on its execution and any errors.
    ///
    public func dispatch(_ action: Action) async throws {
        try await _dispatch(action)
    }

    private func reduce(action: Action) {
        objectWillChange.send()

        if let register = action as? Register {
            addModel(model: register.model)
        }

        for property in modelKeyPaths {
            var value = property.get(on: models)!

            if let replace = action as? Store.Replace,
               type(of: replace.model) == type(of: value) {
                value = replace.model
            }

            value.update(action: action)
            try! property.set(to: value, on: &models)
        }
    }

    // MARK: - Models

    private func addModel(model: Model) {
        models.append(model)
        modelKeyPaths = DynamicKeyPath<Model>
            .all(on: models)
            .sorted { $0.path.count > $1.path.count }
    }

    // TODO: Try and improve and simplify the find methods on offer here.

    public func find<ModelType:Model>(_ type: ModelType.Type) -> ModelType? {
        modelKeyPaths
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

}
