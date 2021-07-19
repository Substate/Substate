import SwiftUI
import Substate

struct TodosView: View {
    var body: some View {
        Container(Todos.self) { state, dispatch in
            List {
                ForEach(state.list) { todo in
                    HStack {
                        Text(todo.date, style: .time)
                        Text(todo.body)
                    }
                }

                if state.list.isEmpty {
                    Text("No Todos").foregroundColor(.secondary)
                }
            }
        }
    }
}

// TODO: Previews

extension Todos {
    static let empty = Todos(list: [])
    static let testSample = Todos(list: [
        .init(date: Date(), body: "Lorem ipsum."),
        .init(date: Date.distantFuture, body: "Dolor sit amet."),
        .init(date: Date.distantPast, body: "Consectetur adipiscing.")
    ])
}

struct TodosViewPreviews: PreviewProvider {
    static var previews: some View {
        TodosView().state(Todos.empty)
        TodosView().state(Todos.testSample)
    }
}
