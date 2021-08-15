import Foundation
import Substate

public class Inspector: Middleware {

    public init() {}

    /// A makeshift model for log entries.
    /// Lots more work to do to create something good here that works well with whatever we end up with on the client.
    ///
    struct LogEntry: Identifiable, Codable {
        let date: Date
        let type: String
        let components: [String]

        var id: Date { date }
    }

    public func update(store: Store) -> (@escaping Update) -> Update {
        return { next in
            return { action in

                let components = String(reflecting: type(of: action))
                    .split(separator: ".")
                    .map(String.init)

                let entry = LogEntry(date: .init(), type: "Action", components: components)
                let data = try! JSONEncoder().encode(entry)

                let url = URL(string: "http://lucy.local:3000")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = data

                URLSession.shared.dataTask(with: request) { data, response, error in }.resume()




                ///
                next(action)
            }
        }
    }

}
