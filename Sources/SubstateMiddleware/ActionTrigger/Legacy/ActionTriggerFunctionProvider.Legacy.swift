//import Substate
//
///// Protocol tying together single triggers and lists of triggers.
/////
///// Required to allow nesting of trigger lists.
/////
///// - TODO: Improve naming
/////
//public protocol ActionTriggerFunctionProvider {
//    var triggers: [ActionTriggerFunction] { get }
//}
//
//extension ActionTriggerList: ActionTriggerFunctionProvider {}
//
//extension ActionTriggerFunctionWrapper: ActionTriggerFunctionProvider {
//    public var triggers: [ActionTriggerFunction] { [trigger] }
//}
