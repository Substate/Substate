import SwiftUI
import SubstateUI

struct ListView: View {

    var body: some View {
        ListViewModel.select { model in
            TaskList.select { list in
                ScrollView {
                    VStack(spacing: 16) {

                        let update = { (a: Any) in } // TEMP!

                        // Is this good? Passing in the data in the view?

                        ForEach(model.sort(tasks: list.all)) { task in
                            VStack {
                                Text(task.date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text(task.body)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Button("Delete") { update(TaskList.Delete(id: task.id)) }
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .padding()
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
