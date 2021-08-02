/// Tag actions with `LoggedAction` to log them when the logger’s filter is active
///
/// ```swift
/// struct MyAction: Action, LoggedAction {}
/// let logger = ActionLogger(filter: true)
/// ```
///
public protocol LoggedAction {}
