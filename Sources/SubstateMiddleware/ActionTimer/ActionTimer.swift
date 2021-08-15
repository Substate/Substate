import Foundation
import Substate

/// TODO: More accurate timing method
/// TODO: Use signposts to allow testing with instruments?
/// TODO: Provide access to values as well as just printing them
///
public class ActionTimer: Middleware {

    private let filter: Bool
    private var history: [String:[TimeInterval]] = [:]

    public init(filter: Bool = false) {
        self.filter = filter
    }

    // TODO: Plain numeric values with a custom print formatter
    private struct Values {
        let action: String
        let current: String
        let min: String
        let max: String
        let avg: String

        init(action: Action, current: String, min: String, max: String, avg: String) {
            self.action = String(describing: type(of: action))
            self.current = current
            self.min = min
            self.max = max
            self.avg = avg
        }
    }

    public func update(store: Store) -> (@escaping Update) -> Update {
        return { next in
            return { [self] action in
                if (filter && action is TimedAction) || !filter {
                    let start = Date()
                    next(action)
                    let elapsed = Date().timeIntervalSince(start)

                    // TODO: Actions from different modules will fall in same bucket?
                    let name = String(describing: type(of: action))
                    history[name, default: []].append(elapsed)

                    let arr = history[name]!
                    let sum = arr.reduce(0.0, +)
                    let avg = sum / max(TimeInterval(arr.count), 1)
                    let min = arr.min() ?? 0
                    let max = arr.max() ?? 0

                    let values = Values(
                        action: action,
                        current: ms(elapsed),
                        min: ms(min),
                        max: ms(max),
                        avg: ms(avg)
                    )

                    dump(values, name: "Substate.ActionTimer")
                }
            }
        }
    }

    private func ms(_ interval: TimeInterval) -> String {
        String(format: "%.1fms", interval * 1000)
    }

}
