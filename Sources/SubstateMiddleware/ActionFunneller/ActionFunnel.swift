import Substate

public struct ActionFunnel: Model {

    let action: Action
    private let steps: [ActionFunnelStep]
    private var index = 0
    var hasSentCompletion = false

    var isComplete: Bool {
        index >= steps.count
    }

    public init(for action: Action, steps: [ActionFunnelStep]) {
        self.action = action
        self.steps = steps
    }

#if compiler(>=5.4)
    public init(for action: Action, @ActionFunnelStepListBuilder steps: () -> [ActionFunnelStep]) {
        self.action = action
        self.steps = steps()
    }
#endif

#if compiler(>=5.4)
    @resultBuilder public struct ActionFunnelStepListBuilder {
        public static func buildBlock(_ steps: ActionFunnelStep...) -> [ActionFunnelStep] { steps }
    }
#endif

    public mutating func update(action: Action) {
        guard !isComplete else { return }

        if steps[index](action) {
            index += 1
        }
    }

}
