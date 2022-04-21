import Combine
import Substate

extension Publisher where Self : Sendable, Self.Failure == Never {

    @available(iOS 15, macOS 12.0, *)
    @MainActor public func trigger<A1:Action>(_ result: @autoclosure @escaping @Sendable () -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, _ in
            AsyncStream { continuation in
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

    @available(iOS 15, macOS 12.0, *)
    @MainActor public func trigger<A1:Action>(_ result: @escaping @Sendable () -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, _ in
            AsyncStream { continuation in
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

    @available(iOS 15, macOS 12.0, *)
    @MainActor public func trigger<A1:Action>(_ transform: @escaping @Sendable (Output) -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, _ in
            AsyncStream { continuation in
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

