import SwiftUI
import SubstateUI

struct ListView: View {

    var body: some View {
        ListViewModel.map { model, update in
            TaskList.map { list in

                GeometryReader { geometry in
                    ScrollView {
                        List {
                            Section(header: Text("Upcoming")) {
                                ForEach(model.sort(tasks: list.all)) { task in
                                    ListRowView(task: task, onDelete: { id in
                                        update(TaskList.Delete(id: task.id))
                                    })
                                }
                            }

                            Section(header: Text("Completed")) {
                                ForEach(model.sort(tasks: list.all)) { task in
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
    }

}

struct ListViewPreviews: PreviewProvider {
    static var previews: some View {
        ListView()
            .model(TodosAppModel.example)
            .previewLayout(.sizeThatFits)
    }
}
