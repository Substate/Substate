import SwiftUI
import SubstateUI

struct TabsContainer: View {

    @Value(\Tabs.current, Tabs.Select.init) var tab: Tab

    var body: some View {
        TabView(selection: $tab) {
            TasksScreen()
                .tabItem { Label("Tasks", systemImage: "checkmark.circle") }
                .tag(Tab.tasks)

            SettingsScreen()
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(Tab.settings)
        }

    }

}
