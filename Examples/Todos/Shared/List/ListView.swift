import SwiftUI
import SubstateUI

struct ListView: View {

    @Send var send

    @Model var filter: Filter
    @Model var list: Tasks

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                List {
                    Section(header: Text(String(describing: filter.category).capitalized)) {
                        // TODO: Filter!
                        ForEach(list.all) { task in
                            ListRowView(task: task, onTap: { id in
                                send(Tasks.Toggle(id: id))
                            }, onDelete: { id in
                                send(Tasks.Delete(id: id))
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
            .model(Tasks.sample)
            .previewLayout(.sizeThatFits)
    }
}
