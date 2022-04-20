import Substate

extension AsyncSequence where Self : Sendable {

    @MainActor public func trigger<A1:Action>(_ result: @autoclosure @escaping @Sendable () -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, _ in
            AsyncStream { continuation in
                guard action is Store.Start else {
                    // Only run this subscription setup at launch.
                    continuation.finish()
                    return
                }

                Task {
                    do {
                        for try await _ in self {
                            if let output = result() {
                                continuation.yield(output)
                            }
                        }

                        continuation.finish()
                    } catch {
                        continuation.finish()
                    }
                }
            }
        }
    }

    @MainActor public func trigger<A1:Action>(_ result: @escaping @Sendable () -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, _ in
            AsyncStream { continuation in
                guard action is Store.Start else {
                    // Only run this subscription setup at launch.
                    continuation.finish()
                    return
                }

                Task {
                    do {
                        for try await _ in self {
                            if let output = result() {
                                continuation.yield(output)
                            }
                        }

                        continuation.finish()
                    } catch {
                        continuation.finish()
                    }
                }
            }
        }
    }

    @MainActor public func trigger<A1:Action>(_ transform: @escaping @Sendable (Element) -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, _ in
            AsyncStream { continuation in
                guard action is Store.Start else {
                    // Only run this subscription setup at launch.
                    continuation.finish()
                    return
                }

                Task {
                    do {
                        for try await element in self {
                            if let output = transform(element) {
                                continuation.yield(output)
                            }
                        }

                        continuation.finish()
                    } catch {
                        continuation.finish()
                    }
                }
            }
        }
    }

}
