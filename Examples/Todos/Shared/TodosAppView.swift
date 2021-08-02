import SwiftUI

struct TodosAppView: View {

    var body: some View {
        VStack(spacing: 0) {
            TitlebarView()
            ListView()
            NotificationsView()
            ToolbarView()
        }
    }

}

struct TodosAppViewPreviews: PreviewProvider {

    static var previews: some View {
        TodosAppView().model(TodosAppModel.example)
    }

}
