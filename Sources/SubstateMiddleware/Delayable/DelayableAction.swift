import Foundation

public protocol DelayableAction {
    var delay: DispatchTimeInterval { get }
}
