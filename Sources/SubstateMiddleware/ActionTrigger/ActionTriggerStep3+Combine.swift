import Substate

extension ActionTriggerStep3 {

    @available(*, unavailable, message: "Can’t combine with a new value — the chain already contains 3, which is the limit")
    public func combine<V1>(with value: V1) -> ActionTriggerStep3<Output1, Output2, Output3> {
        fatalError()
    }

    @available(*, unavailable, message: "Can’t combine with a new value — the chain already contains 3, which is the limit")
    public func combine<M1:Model>(with model: M1.Type) -> ActionTriggerStep3<Output1, Output2, Output3> {
        fatalError()
    }

    @available(*, unavailable, message: "Can’t combine with a new value — the chain already contains 3, which is the limit")
    public func combine<M1:Model, V1>(with model: KeyPath<M1, V1>) -> ActionTriggerStep3<Output1, Output2, Output3> {
        fatalError()
    }

}
