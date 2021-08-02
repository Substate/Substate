extension Store {

    /// Notification that the store will start.
    ///
    public struct Start: Action {}

    /// Notification that the store will begin its setup phase.
    ///
    /// The setup phase is where all middleware is initialised, so middleware may begin generating
    /// actions from this point.
    ///
    public struct Setup: Action {}

    /// Notification that the setup phase has completed.
    ///
    /// Anything relying on middleware being up and running should catch this action.
    ///
    public struct SetupDidComplete: Action {}

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
    /// by the store directly without passing through the model’s ``Model/update(action:)`` method.
    ///
    public struct Replace: Action {
        let model: Model

        public init(model: Model) {
            self.model = model
        }
    }

}
