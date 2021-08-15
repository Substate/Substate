import SwiftUI
import SubstateUI

struct TodosAppView: View {

    @Model var settings: Settings

    var body: some View {
        TabsContainer()
            .accentColor(settings.theme.primaryColour)
            .preferredColorScheme(settings.colorScheme)
    }

}

struct TodosAppViewPreviews: PreviewProvider {

    static var previews: some View {
        TodosAppView().model(TodosAppModel.preview)
    }

}
