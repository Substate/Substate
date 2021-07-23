import SwiftUI
import SubstateUI

struct TitlebarView: View {

    var body: some View {
        TitlebarViewModel.select { model in
            HStack {
                Text(model.title)
                    .font(.system(.headline, design: .rounded))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground).ignoresSafeArea())
        }
    }

}

struct TitlebarViewPreviews: PreviewProvider {

    static var previews: some View {
        Group {
            TitlebarView().state(TitlebarViewModel.example)
        }
        .previewLayout(.sizeThatFits)
    }

}

