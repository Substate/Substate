import SwiftUI
import SubstateUI

struct ToolbarView: View {

    @Update var update
    @Model var model: ToolbarViewModel

    var body: some View {
        VStack(spacing: 32) {
            switch model.step {

            case .idle:
                EmptyView()

            case .adding(let string):
                HStack {
                    let binding = Binding<String> (
                        get: { string },
                        set: { update(ToolbarViewModel.AddBodyDidChange(body: $0)) }
                    )

                    TextField("Body...", text: binding)
                        .submitLabel(.done)
                        .onSubmit {
                            update(ToolbarViewModel.AddWasCommitted(body: string))
                        }

                    Button(action: update(ToolbarViewModel.AddWasCommitted(body: string))) {
                        Text("Save")
                    }
                    .disabled(!model.canSaveAddedTask)
                }

            case .searching(let string):
                TextField("Query...", text: .constant(string))
            }

            HStack {
                Button(action: update(ToolbarViewModel.AddButtonWasPressed())) {
                    VStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add")
                    }
                }

                Spacer()

                Button(action: update(ToolbarViewModel.SearchButtonWasPressed())) {
                    VStack {
                        Image(systemName: "magnifyingglass.circle.fill")
                        Text("Search")
                    }
                }

                VStack {
                    Image(systemName: "arrow.up.circle.fill")
                    Text("Asc")
                }

                VStack {
                    Image(systemName: "arrow.down.circle.fill")
                    Text("Desc")
                }
            }
        }
        .padding()
        .background(backgroundColor.ignoresSafeArea())
    }

    var backgroundColor: Color {
        #if os(macOS)
        Color.gray
        #else
        Color(.secondarySystemBackground)
        #endif
    }
}

struct ToolbarViewPreviews: PreviewProvider {

    static var previews: some View {
        Group {
            ToolbarView().model(ToolbarViewModel.initial)
            // ToolbarView().model(ToolbarViewModel.searchExample)
        }
        .previewLayout(.sizeThatFits)
    }

}
