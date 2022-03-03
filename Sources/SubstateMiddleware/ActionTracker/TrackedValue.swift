import Foundation
import Substate

/// Wrapper allowing action and model properties to be included in tracking property dictionaries.
///
@MainActor public struct TrackedValue {

    let resolve: (Action, Find) -> Any?

    public init<A:Action, V:Any>(_ actionKeyPath: KeyPath<A, V>) {
        resolve = { action, find in
            (action as? A)?[keyPath: actionKeyPath]
        }
    }

    public init<M:Model, V:Any>(_ modelKeyPath: KeyPath<M, V>) {
        resolve = { action, find in
            (find(M.self).first as? M)?[keyPath: modelKeyPath]
        }
    }

}
