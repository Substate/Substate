import Substate

public struct ActionTriggers {

    public let triggers: [ActionTrigger]

    public init(triggers: [ActionTriggerProvider]) {
        self.triggers = triggers.flatMap(\.triggers)
    }

    #if compiler(>=5.4)

    public init(@ActionTriggersBuilder triggers: () -> [ActionTriggerProvider]) {
        self.triggers = triggers().flatMap(\.triggers)
    }

    @resultBuilder public struct ActionTriggersBuilder {
        public static func buildBlock(_ triggers: ActionTriggerProvider...) -> [ActionTriggerProvider] {
            triggers
        }
    }

    #endif

    func run(action: Action, find: (Model.Type) -> Model?) -> [Action] {
        triggers.compactMap { $0(action, find) }
    }

}

extension ActionTriggers: ActionTriggerProvider {}

extension ActionTriggers: Middleware {
    public func update(send: @escaping Send, find: @escaping Find) -> (@escaping Send) -> Send {
        return { next in
            return { action in
                self.triggers.forEach { trigger in
                    trigger(action, { find($0).first }).map(send)
                }

                next(action)
            }
        }
    }
}
