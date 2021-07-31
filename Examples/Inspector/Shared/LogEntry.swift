import Foundation

/// A makeshift model for log entries.
/// Lots more work to do to create something good here that works well with whatever we end up with on the client.
///
struct LogEntry: Identifiable, Codable {
    let date: Date
    let type: String
    let components: [String]

    var id: Date { date }
}
