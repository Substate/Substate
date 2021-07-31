import SwiftUI
import SubstateUI

struct ListRowView: View {

    let task: Task

    let onTap: (UUID) -> Void
    let onDelete: (UUID) -> Void

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
                .foregroundColor(.yellow)
                .font(.largeTitle)

            VStack {
                Text(task.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(task.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.vertical, 4)
        .onTapGesture { onTap(task.id) }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: { onDelete(task.id) }) {
                Label("Delete", systemImage: "trash.fill")
            }
            
        }
    }

}

struct ListRowViewPreviews: PreviewProvider {

    static var previews: some View {
        List {
            ListRowView(task: .sample1, onTap: { _ in }, onDelete: { _ in })
            // ListRowView(task: .sample2, onDelete: { _ in })
            // ListRowView(task: .sample3, onDelete: { _ in })
        }
        .previewLayout(.sizeThatFits)
    }

}
