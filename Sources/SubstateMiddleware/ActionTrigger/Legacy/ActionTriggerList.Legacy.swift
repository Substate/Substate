//import Substate
//
//public struct ActionTriggerList {
//
//    public let triggers: [ActionTriggerFunction]
//
//    public init(triggers: [ActionTriggerFunction]) {
//        self.triggers = triggers
//    }
//
//#if compiler(>=5.4)
//    public init(@ActionTriggerListBuilder providers: () -> [ActionTriggerFunctionProvider]) {
//        self.triggers = providers().flatMap(\.triggers)
//    }
//
//    @resultBuilder public struct ActionTriggerListBuilder {
//        public static func buildBlock(_ providers: ActionTriggerFunctionProvider...) -> [ActionTriggerFunctionProvider] {
//            providers
//        }
//    }
//#endif
//
//}
