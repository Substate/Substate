import SwiftUI
import SubstateUI

struct ListView: View {

    @Update var update
    @Model var list: TaskList

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                List {
                    Section(header: Text(String(describing: list.filter.category).capitalized)) {
                        ForEach(list.filteredTasks) { task in
                            ListRowView(task: task, onTap: { id in
                                update(TaskList.Toggle(id: id))
                            }, onDelete: { id in
                                update(TaskList.Delete(id: id))
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
            .model(TaskList.sample)
            .previewLayout(.sizeThatFits)
    }
}
