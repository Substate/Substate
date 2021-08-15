import SwiftUI

struct NotificationView: View {

    let notification: Notifications.Notification

    var body: some View {
        HStack {
            Image(systemName: "xmark.circle.fill")
            Text(notification.message)
        }
        .font(.system(.body, design: .rounded).weight(.medium))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .foregroundColor(Color(.systemBackground))
        .background(Color.accentColor)
        .mask(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

}

struct NotificationViewPreviews: PreviewProvider {

    static var previews: some View {
        NotificationView(notification: .preview)
            // .previewLayout(.sizeThatFits)
    }

}
