public protocol ActionTriggerProvider {
    @MainActor var triggers: [ActionTrigger] { get }
}
