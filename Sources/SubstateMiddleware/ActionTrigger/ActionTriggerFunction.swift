import Substate

/// The final type-erased function stored to compute each trigger’s result.
///
public typealias ActionTriggerFunction = (Action, (Model.Type) -> Model?) -> Action?

/// Wrapper to allow mixing singles/groups of trigger functions in result builder
///
/// - TODO: Better naming!
///
public struct ActionTriggerFunctionWrapper {
    public let trigger: ActionTriggerFunction
    public init(trigger: @escaping ActionTriggerFunction) {
        self.trigger = trigger
    }
}
