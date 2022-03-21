import Foundation
import Substate

/// Wrapper allowing action and model properties to be included in tracking property dictionaries.
///
public struct TrackedValue {

    let resolve: (Action, Find) async -> AnyHashable?

    public static func action<A:Action, V:Hashable>(_ actionKeyPath: KeyPath<A, V>) -> TrackedValue {
        .init { action, find in
            (action as? A)?[keyPath: actionKeyPath]
        }
    }

    public static func model<M:Model, V:Hashable>(_ modelKeyPath: KeyPath<M, V>) -> TrackedValue {
        .init { action, find in
            (await find(M.self).first as? M)?[keyPath: modelKeyPath]
        }
    }

    public static func constant<V:Hashable>(_ constant: V) -> TrackedValue {
        .init { action, find in
            constant
        }
    }

}
