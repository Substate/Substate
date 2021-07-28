extension Store {

    /// Directly replace all models of the same type as the one provided with its value.
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
