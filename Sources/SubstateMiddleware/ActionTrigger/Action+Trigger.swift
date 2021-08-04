import Substate

extension Action {

    /// 1. Trigger a constant action.
    ///
    /// - Action1.trigger(Action2(value: 123))
    ///
    public static func trigger<A2>(_ result: @autoclosure @escaping () -> A2) -> ActionTriggerFunctionWrapper where A2: Action {
        ActionTriggerFunctionWrapper(trigger:
            { action, find in
                action is Self ? result() : nil
            }
        )
    }

    /// 2. Trigger a function taking no parameters.
    ///
    /// - Action1.trigger(Action2.init)
    ///
    public static func trigger<A2>(_ result: @escaping () -> A2?) -> ActionTriggerFunctionWrapper where A2: Action {
        ActionTriggerFunctionWrapper(trigger:
            { action, find in
                return action is Self ? result() : nil
            }
        )
    }

    /// 3. Trigger a function taking the action itself.
    ///
    /// - Action1.trigger(Action2.init(action:))
    ///
    public static func trigger<A2>(_ result: @escaping (Self) -> A2?) -> ActionTriggerFunctionWrapper where A2: Action {
        ActionTriggerFunctionWrapper(trigger:
            { action, find in
                if let action = action as? Self {
                    return result(action)
                } else {
                    return nil
                }
            }
        )
    }

    /// 4a. Map over one or more action properties.
    ///
    /// - Action1.map(\.value).trigger(Action2.init(value:))
    ///
    public static func map<V1>(_ value: KeyPath<Self, V1>) -> ActionTriggerStepActionValueMap1<Self, V1> {
        ActionTriggerStepActionValueMap1(action: self, value: value)
    }

    // TODO: Fill out 1+ action properties

    /// 5a. Mapping one or more models.
    ///
    /// - Action1.map(Model1.self).trigger(Action2.init(model:))
    ///
    public static func map<M1>(_ model: M1.Type) -> ActionTriggerStepModelMap1<Self, M1> where M1: Model {
        ActionTriggerStepModelMap1(action: self, model: model)
    }

    // TODO: Fill out 1+ models

    /// 6a. Mapping one or more model properties.
    ///
    /// - Action1.map(\Model1.value).trigger(Action2.init(value:))
    ///
    public static func map<M1, V1>(_ value: KeyPath<M1, V1>) -> ActionTriggerStepModelValueMap1<Self, M1, V1> where M1: Model {
        ActionTriggerStepModelValueMap1(action: self, value: value)
    }

    // TODO: Fill out 1+ model properties

    // ...

    /// 8a. Mapping an action property and one or more model properties.
    ///
    /// - Action1.map(\.value, \Model1.value).trigger(Action2(value1:value2:))
    ///
    public static func map<V0, M1, V1>(_ value: KeyPath<Self, V0>, _ value2: KeyPath<M1, V1>) -> ActionTriggerStepActionValueMap1ModelValueMap1<Self, V0, M1, V1> where M1: Model {
        ActionTriggerStepActionValueMap1ModelValueMap1(value: value, value2: value2)
    }

    // TODO: Fill out 1+ model properties

    // Map to any value for input into trigger step.
    public static func map<V1>(_ transform: @escaping (Self) -> V1) -> ActionTriggerStepAnyValueMap1<Self, V1> {
        ActionTriggerStepAnyValueMap1(action: self, transform: transform)
    }
}

public struct ActionTriggerStepActionValueMap1<A1, V1> where A1: Action {
    let action: A1.Type
    let value: KeyPath<A1, V1>

    public func trigger<A2>(_ result: @escaping (V1) -> A2?) -> ActionTriggerFunctionWrapper where A2: Action {
        ActionTriggerFunctionWrapper(trigger:
            { action, find in
                guard let action = action as? A1 else { return nil }
                return result(action[keyPath: value])
            }
        )
    }
}

public struct ActionTriggerStepModelMap1<A1, M1> where A1: Action, M1: Model {
    let action: A1.Type
    let model: M1.Type

    public func trigger<A2>(_ result: @escaping (M1) -> A2?) -> ActionTriggerFunctionWrapper where A2: Action {
        ActionTriggerFunctionWrapper(trigger:
            { action, find in
                guard action is A1 else { return nil }
                guard let model = find(M1.self) as? M1 else { return nil }
                return result(model)
            }
        )
    }
}

public struct ActionTriggerStepModelValueMap1<A1, M1, V1> where A1: Action, M1: Model {
    let action: A1.Type
    let value: KeyPath<M1, V1>

    public func trigger<A2>(_ result: @escaping (V1) -> A2?) -> ActionTriggerFunctionWrapper where A2: Action {
        ActionTriggerFunctionWrapper(trigger:
            { action, find in
                guard action is A1 else { return nil }
                guard let model = find(M1.self) as? M1 else { return nil }
                return result(model[keyPath: value])
            }
        )
    }
}

public struct ActionTriggerStepActionValueMap1ModelValueMap1<A, AV, M, MV> where A: Action, M: Model {
    let value: KeyPath<A, AV>
    let value2: KeyPath<M, MV>

    public func trigger<A2>(_ result: @escaping (AV, MV) -> A2?) -> ActionTriggerFunctionWrapper where A2: Action {
        ActionTriggerFunctionWrapper(trigger:
            { action, find in
                guard let action = action as? A else { return nil }
                guard let model = find(M.self) as? M else { return nil }

                return result(action[keyPath: value], model[keyPath: value2])
            }
        )
    }
}

public struct ActionTriggerStepAnyValueMap1<A1, V1> where A1: Action {
    let action: A1.Type
    let transform: (A1) -> V1

    public func trigger<A2>(_ result: @escaping (V1) -> A2?) -> ActionTriggerFunctionWrapper where A2: Action {
        ActionTriggerFunctionWrapper(trigger:
            { action, find in
                guard let action = action as? A1 else { return nil }
                return result(transform(action))
            }
        )
    }
}

extension ActionTriggerStepAnyValueMap1 where V1: Action {
    public func trigger() -> ActionTriggerFunctionWrapper {
        ActionTriggerFunctionWrapper(trigger:
            { action, find in
                guard let action = action as? A1 else { return nil }
                return transform(action)
            }
        )
    }
}
