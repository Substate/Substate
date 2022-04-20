/// As of Swift 5.6, `KeyPath` is apparently not `Sendable`, which results in a lot of warnings
/// across this project. Based on some reading, it looks as if this is because in some cases
/// keypaths can capture values in their definitions (eg. an array index). Based on what little
/// commentary exists online (eg. https://zenn.dev/iceman/articles/03aa70ef1372cf), it looks to be
/// safe to mark `KeyPath` as `Sendable` if its value type also is. To be revisited.

extension KeyPath: @unchecked Sendable where Value: Sendable {}
