import Foundation

struct Task: Identifiable {
    let id: UUID
    let date: Date
    var body: String
    var completed = Bool.random()
}

extension Task {
    static let sample1 = Task(id: .init(), date: .init(), body: "Lorem ipsum dolor sit amet.")
    static let sample2 = Task(id: .init(), date: .distantFuture, body: "Consectetur adipiscing elit sed.")
    static let sample3 = Task(id: .init(), date: .distantPast, body: "Do eismod tempor elit.")
}
