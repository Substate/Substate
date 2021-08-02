import SwiftUI
import SubstateUI

struct NotificationsView: View {

    @Update var update
    @Model var notifications: Notifications

    var body: some View {
        VStack {
            ForEach(notifications.notifications) { notification in
                Text(notification.message)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.yellow)
                    .mask(RoundedRectangle(cornerRadius: 4, style: .continuous))
                    .foregroundColor(.black)
                    .onTapGesture { update(Notifications.Dismiss(id: notification.id)) }
                    .id(notification.id)
                    .transition(.opacity.animation(.default))
            }
        }
        .padding()
    }

}
