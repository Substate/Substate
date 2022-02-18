import Substate

extension Action {

    /// Map an action to 1 property.
    ///
    /// - Action1.map { (a: Action1) in a.value }
    ///
    public static func map<V1>(_ transform: @escaping (Self) -> V1) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1 { action, find in
            AsyncStream { continuation in
                Task {
                    if let action = action as? Self {
                        let result = transform(action)
                        continuation.yield(result)
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Map an action to 2 properties.
    ///
    /// - Action1.map(\.value1, \.value2)
    ///
    public static func map<V1, V2>(_ transform1: @escaping (Self) -> V1, _ transform2: @escaping (Self) -> V2) -> ActionTriggerStep2<V1, V2> {
        ActionTriggerStep2 { action, find in
            AsyncStream { continuation in
                Task {
                    if let action = action as? Self {
                        let result = (transform1(action), transform2(action))
                        continuation.yield(result)
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Map an action to 2 properties.
    ///
    /// - Action1.map(\.value1, \.value2, \.value3)
    ///
    public static func map<V1, V2, V3>(_ transform1: @escaping (Self) -> V1, _ transform2: @escaping (Self) -> V2, _ transform3: @escaping (Self) -> V3) -> ActionTriggerStep3<V1, V2, V3> {
        ActionTriggerStep3 { action, find in
            AsyncStream { continuation in
                Task {
                    if let action = action as? Self {
                        let result = (transform1(action), transform2(action), transform3(action))
                        continuation.yield(result)
                    }
                }

                continuation.finish()
            }
        }
    }

    /// Compact map an action.
    ///
    /// - Action1.compactMap(\.optionalValue)
    ///
    public static func compactMap<V1>(_ transform: @escaping (Self) -> V1?) -> ActionTriggerStep1<V1> {
        ActionTriggerStep1 { action, find in
            AsyncStream { continuation in
                Task {
                    if let action = action as? Self, let result = transform(action) {
                        continuation.yield(result)
                    }
                }

                continuation.finish()
            }
        }
    }

}
