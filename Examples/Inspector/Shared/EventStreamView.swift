import SwiftUI
import SubstateUI

struct EventStreamView: View {

    @Update var update
    @Model var stream: EventStream
    @Model var toolbar: Toolbar

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    ForEach(stream.groups) { group in
                        VStack(alignment: .leading) {
                            Text(group.events.first!.date, formatter: Self.dateFormatter)
                                .font(.system(.callout, design: .monospaced))
                                .foregroundColor(.secondary.opacity(0.5))

                            HStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .frame(width: 8)
                                    .blendMode(.destinationOut)

                                VStack(alignment: .leading, spacing: 12) {
                                    ForEach(group.events) { event in
                                        EventRowView(event: event).id(event.id)
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray).opacity(0.15))
                        .compositingGroup()
                        .mask(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .id(group.id)
                    }
                }
                .padding()
            }
            .onChange(of: stream.groups) { groups in
                guard toolbar.sync else { return }
                guard let group = groups.last else { return }

                withAnimation {
                    proxy.scrollTo(group.id, anchor: .top)
                }
            }
        }
        .navigationTitle("Substate")
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: { update(Toolbar.ToggleSync()) }) {
                    Label("Live", systemImage: toolbar.sync ? "pause.circle.fill" : "play.circle.fill")
                }
                .foregroundColor(toolbar.sync ? .accentColor : nil)

                Button(action: { update(EventStream.Clear()) }) {
                    Label("Clear", systemImage: "xmark.circle")
                }

                TextField("Search", text: .constant(""))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minWidth: 200)
            }

        }
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd H:m:ss.SSS"
        return formatter
    }()

}

struct EventStreamViewPreviews: PreviewProvider {
    static var previews: some View {
        EventStreamView().model(EventStream.sample)
    }
}
