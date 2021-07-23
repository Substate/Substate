import SwiftUI
import SubstateUI

struct ListView: View {

    var body: some View {
        Select(ListViewModel.self) { model, update in
            Select(TaskList.self) { list, update in
                VStack(spacing: 32) {


                    Button("Create") {
                        update(TaskList.Create(body: "Lorem ipsum dolor sit amet"))
                    }

                    // Is this good? Passing in the data in the view?

                    ForEach(model.sort(tasks: list.all)) { task in
                        VStack(alignment: .leading) {
                            Text(task.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Text(task.body)

                            Button("Delete") { update(TaskList.Delete(id: task.id)) }
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }

                }
            }
        }
    }

}

struct ListViewPreviews: PreviewProvider {
    static var previews: some View {
        ListView()
            .state(TaskList.sample)
            .previewLayout(.sizeThatFits)
    }
}
