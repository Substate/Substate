import SwiftUI

struct EventDetailView: View {

    let event: Event

    var body: some View {
        Text(event.date, style: .date)
    }

}
