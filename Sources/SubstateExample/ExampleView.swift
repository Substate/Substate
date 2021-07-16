import SwiftUI
import Substate

struct TodosView: View {
    var body: some View {
        Container(for: Todos.self) { state, dispatch in
            ForEach(state.list) { todo in
                // ...
            }
        }
    }
}

// TODO: Previews
