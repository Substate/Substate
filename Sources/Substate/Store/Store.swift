import Foundation

/// Stores all models and provides action dispatch.
///
@MainActor public final class Store: ObservableObject {

    private var models: [any Model] = []
    private var modelKeyPaths: [DynamicKeyPath<Model>] = []

    private lazy var _dispatch: DispatchFunction = reduce

    // MARK: - Initialization

    /// Create a store, and ignore its initial dispatch and any errors.
    ///
    public init(model: any Model, middleware: [any Middleware] = []) {
        addModel(model: model)
        addMiddleware(middleware: middleware)
        Task { try? await _dispatch(Start()) }
    }

    /// Create a store, and wait on its initial dispatch and any errors.
    ///
    public init(model: any Model, middleware: [any Middleware] = []) async throws {
        addModel(model: model)
        addMiddleware(middleware: middleware)
        try await dispatch(Start())
    }

    private func addModel(model: any Model) {
        models.append(model)
        modelKeyPaths = DynamicKeyPath<Model>
            .all(on: models)
            .sorted { $0.path.count > $1.path.count }
    }

    private func addMiddleware(middleware: [any Middleware]) {
        for middleware in middleware.reversed() {
            _dispatch = middleware.configure(store: self)(_dispatch)
        }
    }

    // MARK: - Action Dispatch

    /// Dispatch an action and ignore its execution and any errors.
    ///
    public func dispatch(_ action: any Action)  {
        Task { try? await _dispatch(action) }
    }

    /// Dispatch an action and wait on its execution and any errors.
    ///
    public func dispatch(_ action: any Action) async throws {
        try await _dispatch(action)
    }

    private func reduce(action: any Action) {
        objectWillChange.send() // TODO: Perform equality checking to reduce redraws.

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

    // MARK: - Model Retrieval

    // TODO: Try and improve and simplify the find methods on offer here.
    // Implicitly opened existentials (SE-0352) will help get rid of at least the middle case.

    public func find<T:Model>(_ type: T.Type) -> T? {
        modelKeyPaths
            .first(where: { $0.type == T.self })?
            .get(on: models) as? T
    }

    public func find<T>(_ supertype: T.Type) -> [Model] {
        modelKeyPaths
            .compactMap { $0.get(on: models) }
            .filter { $0 is T }
    }

    public func find(_ modelType: Model.Type? = nil) -> [Model] {
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
