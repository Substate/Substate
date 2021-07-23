import SwiftUI

struct TodosAppView: View {

    var body: some View {
        VStack {
            TitlebarView()
            ListView()
            ToolbarView()
        }
    }

}

struct TodosAppViewPreviews: PreviewProvider {

    static var previews: some View {
        TodosAppView().state(TodosAppModel.example)
    }

}
