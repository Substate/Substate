import SwiftUI
import SubstateUI

struct InspectorAppView: View {

    var body: some View {
//        NavigationView {
//            List {
//                Text("Sidebar Item")
//            }
//            .listStyle(.sidebar)

            EventStreamView()
//        }
        .frame(minWidth: 600, maxWidth: .infinity, minHeight: 800, maxHeight: .infinity)
    }

}

struct InspectorAppViewPreviews: PreviewProvider {
    static var previews: some View {
        InspectorAppView().model(InspectorAppModel.sample)
    }
}
