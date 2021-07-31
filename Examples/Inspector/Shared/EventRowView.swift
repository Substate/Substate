import SwiftUI

struct EventRowView: View {

    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
//            Text(event.type)
//                .font(.system(.callout, design: .monospaced))
//                .foregroundColor(Color(.systemGray))

//            Text(event.date, formatter: Self.dateFormatter)
//                .font(.system(.callout, design: .monospaced))
//                .foregroundColor(.secondary.opacity(0.5))
//                .padding(.leading, 8)

            HStack(spacing: 4) {
                ForEach(event.components.indices, id: \.self) { index in
                    let isFirst = index == 0
                    let isLast = index == event.components.count - 1
                    let color = isFirst ? Color.gray.opacity(0.25) : isLast ? .blue : .gray.opacity(0.75)

                    TagView(text: event.components[index], color: color)
                        .foregroundColor(.white)
                }
            }

        }
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd H:m:ss.SSS"
        return formatter
    }()

}

struct EventRowViewPreviews: PreviewProvider {
    static var previews: some View {
        List {
            EventRowView(event: .sample)
            EventRowView(event: .sample)
            EventRowView(event: .sample)
            EventRowView(event: .sample)
            EventRowView(event: .sample)
        }
    }
}
