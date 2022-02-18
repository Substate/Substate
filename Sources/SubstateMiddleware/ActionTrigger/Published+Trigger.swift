import Combine
import Substate

extension Publisher where Self.Failure == Never {

    public func trigger<A1:Action>(_ result: @autoclosure @escaping () -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, find in
            return AsyncStream { continuation in
                guard action is Store.Start else {
                    // Only run this subscription setup at launch.
                    continuation.finish()
                    return
                }

                Task {
                    for try await _ in values {
                        if let output = result() {
                            continuation.yield(output)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    public func trigger<A1:Action>(_ result: @escaping () -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, find in
            return AsyncStream { continuation in
                guard action is Store.Start else {
                    // Only run this subscription setup at launch.
                    continuation.finish()
                    return
                }

                Task {
                    for try await _ in values {
                        if let output = result() {
                            continuation.yield(output)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    public func trigger<A1:Action>(_ transform: @escaping (Output) -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, find in
            return AsyncStream { continuation in
                guard action is Store.Start else {
                    // Only run this subscription setup at launch.
                    continuation.finish()
                    return
                }

                Task {
                    for try await element in values {
                        if let output = transform(element) {
                            continuation.yield(output)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

}

