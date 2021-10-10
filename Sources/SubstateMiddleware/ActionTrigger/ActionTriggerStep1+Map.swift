extension ActionTriggerStep1 {

    /// Map an action step.
    ///
    public func map<V1>(_ transform: @escaping (Output) -> V1) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1<V1> { action, find in
            run(action: action, find: find).map(transform)
        }
    }

    /// Map an action step over 2 transforms.
    ///
    public func map<V1, V2>(_ transform1: @escaping (Output) -> V1, _ transform2: @escaping (Output) -> V2) -> ActionTriggerStep2<V1, V2> {
        ActionTriggerStep2 { action, find in
            run(action: action, find: find).map { (transform1($0), transform2($0)) }
        }
    }

    /// Map an action step over 3 transforms.
    ///
    public func map<V1, V2, V3>(_ transform1: @escaping (Output) -> V1, _ transform2: @escaping (Output) -> V2, _ transform3: @escaping (Output) -> V3) -> ActionTriggerStep3<V1, V2, V3> {
        ActionTriggerStep3 { action, find in
            run(action: action, find: find).map { (transform1($0), transform2($0), transform3($0)) }
        }
    }

    /// Compact map an action step.
    ///
    public func compactMap<V1>(_ transform: @escaping (Output) -> V1?) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1<V1> { action, find in
            run(action: action, find: find).flatMap(transform)
        }
    }

}
