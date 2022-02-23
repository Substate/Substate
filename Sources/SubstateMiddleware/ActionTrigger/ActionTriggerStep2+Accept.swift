extension ActionTriggerStep2 {

    public func accept(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep2<Output1, Output2> {
        ActionTriggerStep2 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if constant() == true {
                            continuation.yield(output)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    public func accept(when condition: @escaping (Output1, Output2) -> Bool) -> ActionTriggerStep2<Output1, Output2> {
        ActionTriggerStep2 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if condition(output.0, output.1) == true {
                            continuation.yield(output)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    public func accept(when condition: @escaping (Output1, Output2) -> Bool?) -> ActionTriggerStep2<Output1, Output2> {
        ActionTriggerStep2 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if condition(output.0, output.1) == true {
                            continuation.yield(output)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

    // New constant variation, accepting an output-typed values.
    // TODO: Add this to the other action steps and test suite.
    //
    // Might be some cool things that can be done with this variation, eg:
    //
    // ScenePhase.Changed
    //     .map(\.oldValue, \.newValue)
    //     .accept(when: .active, .inactive)
    //     .trigger(...)
    //
    public func accept(when constant1: @autoclosure @escaping () -> Output1, _ constant2: @autoclosure @escaping () -> Output2) -> ActionTriggerStep2<Output1, Output2> where Output1 : Equatable, Output2 : Equatable {
        ActionTriggerStep2 { action, find in
            AsyncStream { continuation in
                Task {
                    for await output in run(action: action, find: find) {
                        if constant1() == output.0 && constant2() == output.1 {
                            continuation.yield(output)
                        }
                    }

                    continuation.finish()
                }
            }
        }
    }

}
