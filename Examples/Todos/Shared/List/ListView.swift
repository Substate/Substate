import SwiftUI
import SubstateUI

struct ListView: View {

    @Update var update

    @Model var taskList: TaskList
    @Model var listViewModel: ListViewModel

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                List {
                    Section(header: Text("Upcoming")) {
                        ForEach(listViewModel.sort(tasks: taskList.all)) { task in
                            ListRowView(task: task, onDelete: { id in
                                update(TaskList.Delete(id: task.id))
                            })
                        }
                    }

                    Section(header: Text("Completed")) {
                        ForEach(listViewModel.sort(tasks: taskList.all)) { task in
                            ListRowView(task: task, onDelete: { id in
                                update(TaskList.Delete(id: task.id))
                            })
                        }
                    }
                }
                .padding(.top)
                .frame(minHeight: geometry.size.height, alignment: .top)
            }
        }
    }

}

struct ListViewPreviews: PreviewProvider {
    static var previews: some View {
        ListView()
            .model(TodosAppModel.example)
            .previewLayout(.sizeThatFits)
    }
}
