import Foundation

public protocol DelayedAction {
    var delay: DispatchTimeInterval { get }
}
