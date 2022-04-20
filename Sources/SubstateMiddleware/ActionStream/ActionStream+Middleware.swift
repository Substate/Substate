import Substate

extension ActionStream: Middleware {

    public func configure(store: Store) -> (@escaping DispatchFunction) -> DispatchFunction {
        self.store = store

        return { next in
            { action in
                try await next(action)
                self.publisher.send(action)
            }
        }
    }

}
