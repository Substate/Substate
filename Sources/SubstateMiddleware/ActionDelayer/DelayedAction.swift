import Foundation

/// Lorem ipsum dolor sit amet consectetur adipiscing elit.
///
/// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut
/// labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco
/// laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in
/// voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat
/// non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
///
/// ```swift
/// struct MyAction: Action, DelayedAction {
///     let delay: TimeInterval = 5
/// }
/// ```
///
/// ```
/// store.update(MyAction())
///
/// > - Substate.ActionDelayer: Scheduling MyAction
/// > ...
/// > ▿ Substate.Action: MyAction
/// >   - delay: 5
/// ```
///
public protocol DelayedAction {

    /// The time interval after which the action will resume.
    ///
    var delay: TimeInterval { get }

}
