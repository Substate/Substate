import Substate

public struct ActionTriggerList {

    let results: [ActionTriggerResult]

    public init(results: [ActionTriggerResult]) {
        self.results = results
    }

#if compiler(>=5.4)
    public init(@ActionTriggerListBuilder results: () -> [ActionTriggerResult]) {
        self.results = results()
    }

    @resultBuilder public struct ActionTriggerListBuilder {
        public static func buildBlock(_ results: ActionTriggerResult...) -> [ActionTriggerResult] {
            results
        }
    }
#endif

}
