import SwiftUI
import Substate

struct MissingStoreView: View {

    var body: some View {
        Label(message, systemImage: "exclamationmark.triangle.fill")
            .font(.system(.caption, design: .rounded).weight(.bold))
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .foregroundColor(.white)
            .background(Color.red)
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    var message: String {
        "Missing Substate Store"
    }

}

struct MissingStoreViewPreviews: PreviewProvider {

    static var previews: some View {
        MissingStoreView()
            .padding()
            .previewLayout(.sizeThatFits)
    }

}
