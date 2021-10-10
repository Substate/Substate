import SwiftUI
import SubstateUI

struct TasksScreen: View {

    @Send var send

    @Model var tasks: Tasks
    @Value(\CreateTaskScreenModel.isActive, CreateTaskScreenModel.Toggle.init) var showCreateScreen

    // @Model var router: Router

    var body: some View {
        NavigationView {

            // TODO: Factor out list view
            // TODO: Nice clean design

            VStack {
                Form {
                    Section(header: Text("Incomplete")) {
                        ForEach(tasks.all) { task in
                            ListRowView(task: task, onTap: { id in
                                send(Tasks.Toggle(id: id))
                            }, onDelete: { id in
                                send(Tasks.Delete(id: id))
                            })
                        }
                    }
                }
                
            }
            .navigationTitle("Tasks")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: addButton)
        }
        .overlay(NotificationsView(), alignment: .bottom)
        // Router would be pretty cool, but how would you integrate a rouder with SwiftUI’s
        // isPresented bindings? How do you know where to go back to?
        .sheet(isPresented: $showCreateScreen) {
            CreateTaskScreen()
        }
    }

    var addButton: some View {
        // Button(action: { update(Router.Go(to: .createTask)) }) {}

        Button(action: { send(CreateTaskScreenModel.Toggle(isActive: true)) }) {
            Label("Create Task", systemImage: "plus.circle.fill")
        }
    }

}
