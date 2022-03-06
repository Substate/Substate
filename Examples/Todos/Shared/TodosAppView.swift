import SwiftUI
import SubstateUI

struct TodosAppView: View {

    @Model var settings: Settings
    @Value(\TodosAppModel.isLoaded) var isLoaded

    var body: some View {
        TabsContainer()
            .opacity(isLoaded ? 1 : 0)
            .animation(.default, value: isLoaded)
            .accentColor(settings.theme.primaryColour)
            .preferredColorScheme(settings.colorScheme)
    }

}

struct TodosAppViewPreviews: PreviewProvider {

    static var previews: some View {
        TodosAppView().model(TodosAppModel.preview)
    }

}
