import Foundation

struct Task: Identifiable {
    let id: UUID
    let date: Date
    var body: String
    var completed = false
}
