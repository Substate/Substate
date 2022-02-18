import Substate

extension AsyncSequence {

    public func trigger<A1:Action>(_ result: @autoclosure @escaping () -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, find in
            return AsyncStream { continuation in
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

    public func trigger<A1:Action>(_ result: @escaping () -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, find in
            return AsyncStream { continuation in
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

    public func trigger<A1:Action>(_ transform: @escaping (Element) -> A1?) -> ActionTriggerStepFinal<A1> {
        ActionTriggerStepFinal { action, find in
            return AsyncStream { continuation in
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
