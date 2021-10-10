import SwiftUI
import SubstateUI

struct NotificationsView: View {

    @Send var send
    @Model var model: Notifications

    var body: some View {
        ZStack {
            ForEach(model.notifications.indices, id: \.self) { index in
                let notification = model.notifications[index]
                let i = Double(model.notifications.count - index) - 1
                let isLast = index == model.notifications.count - 1

                NotificationView(notification: notification)
                    .offset(x: 0, y: i * -8)
                    .opacity(isLast ? 1 : 0.25)
                    .scaleEffect(1 - i * 0.05)
                    .onTapGesture { send(Notifications.Dismiss(id: model.notifications[index].id)) }
                    .id(model.notifications[index].id)
                    .transition(.move(edge: .bottom).animation(.default))
                    .animation(.default)
            }
        }
        .padding(.top)
        .clipped()
        .padding()
    }

}


struct NotificationsViewPreviews: PreviewProvider {

    static var previews: some View {
        NotificationsView()
            .model(Notifications.preview)
            .previewLayout(.sizeThatFits)
    }

}
