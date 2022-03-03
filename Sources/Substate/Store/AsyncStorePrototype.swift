import Foundation

// A sketch of the new async/AsyncStream-based store.

public typealias DispatchFunction = ((Action) async throws -> Void)

public protocol AsyncMiddleware {
    func run(dispatch: @escaping DispatchFunction) -> (@escaping DispatchFunction) -> DispatchFunction
}

@MainActor public final class AsyncStorePrototype: ObservableObject {

    private var state: Model
    private lazy var dispatchClosure: (Action) async throws -> Void = { action in self.reduce(action: action) }

    public init(state: Model, middleware: [AsyncMiddleware] = []) {
        self.state = state

        for middleware in middleware.reversed() {
            dispatchClosure = middleware.run(dispatch: dispatch(action:))(dispatchClosure)
        }
    }

    public func dispatch(action: Action) async {
        try? await dispatchClosure(action)
    }

    private func reduce(action: Action) {
        print("Performing reduce on model for action", action)
    }

}
