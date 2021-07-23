import SwiftUI
import SubstateUI

struct TitlebarView: ModelView {
    typealias Model = TitlebarViewModel

    func body(model: Model, update: Update) -> some View {
        HStack {
            Text(model.title)
                .font(.system(.headline, design: .rounded))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(backgroundColor.ignoresSafeArea())
    }

    var backgroundColor: Color {
        #if os(macOS)
        Color.gray
        #else
        Color(.secondarySystemBackground)
        #endif
    }
}

struct TitlebarViewPreviews: PreviewProvider {

    static var previews: some View {
        Group {
            TitlebarView().model(TitlebarViewModel.example)
        }
        .previewLayout(.sizeThatFits)
    }

}

