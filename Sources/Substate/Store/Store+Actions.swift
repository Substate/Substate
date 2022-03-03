extension Store {

    /// Notification that the store will start.
    ///
    /// This action is sent once only, when the store finishes its `init`. It can be used as a hook
    /// to trigger other initialisation routines.
    ///
    public struct Start: Action {}

    /// Dynamically register a model for use with the store.
    ///
    /// Primarily intended for use with middleware as a way of storing and mutating configuration
    /// information. Middleware may register a model to be held by the store and updated according
    /// to its own `update(action:)` method. Middleware may later query the store for any registered
    /// models and get their values, or dispatch further actions to update them.
    ///
    public struct Register: Action {
        let model: Model

        public init(model: Model) {
            self.model = model
        }
    }

    /// Directly replace all models of type provided with the given value.
    ///
    /// This action is provided as an escape hatch when direct mutation of models is unavoidable. It
    /// is intended to be used sparingly, for example in the `ModelSaver` middleware to
    /// automatically replace models wholesale when they are loaded from disk.
    ///
    /// ```swift
    /// store.update(Store.Replace(model: Counter(value: 456))
    /// ```
    /// 
    /// > Warning: Bear in mind that this action has special baked-in store support, and is actioned
    /// by the store directly before passing through the model’s ``Model/update(action:)`` method.
    ///
    public struct Replace: Action {
        let model: Model

        public init(model: Model) {
            self.model = model
        }
    }

}
