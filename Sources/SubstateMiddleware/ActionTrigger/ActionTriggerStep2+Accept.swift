extension ActionTriggerStep2 {

    public func accept(when constant: @autoclosure @escaping () -> Bool?) -> ActionTriggerStep2<Output1, Output2> {
        ActionTriggerStep2 { action, find in
            await run(action: action, find: find).flatMap { constant() == true ? ($0, $1) : nil }
        }
    }

    public func accept(when condition: @escaping (Output1, Output2) -> Bool) -> ActionTriggerStep2<Output1, Output2> {
        ActionTriggerStep2 { action, find in
            await run(action: action, find: find).flatMap { condition($0, $1) ? ($0, $1) : nil }
        }
    }

    public func accept(when condition: @escaping (Output1, Output2) -> Bool?) -> ActionTriggerStep2<Output1, Output2> {
        ActionTriggerStep2 { action, find in
            await run(action: action, find: find).flatMap { condition($0, $1) == true ? ($0, $1) : nil }
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
            await run(action: action, find: find).flatMap { output1, output2 in
                constant1() == output1 && constant2() == output2 ? (output1, output2) : nil
            }
        }
    }

}
