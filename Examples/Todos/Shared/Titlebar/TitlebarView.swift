import SwiftUI
import SubstateUI

struct TitlebarView: View {

    @Send var send
    @Model var model: Titlebar
    // @ModelBinding(\TitlebarViewModel.filter.category, Filter.Update(category:)) var $category

//    var categoryBinding: Binding<Filter.Category> {
//        .init(
//            get: { model.filter.category },
//            set: { update(Filter.Update(category: $0)) }
//        )
//    }

    var body: some View {
        ZStack {
//            Picker("Filter", selection: categoryBinding) {
//                ForEach(Filter.Category.allCases, id: \.self) { category in
//                    Text(String(describing: category).capitalized)
//                        .tag(category)
//                }
//            }
//            .pickerStyle(.menu)
//            .frame(maxWidth: .infinity, alignment: .leading)

            Text(model.title)
                .fixedSize()
                .font(.system(.headline, design: .rounded))
                .frame(width: 100)
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
            TitlebarView().model(Titlebar.example)
        }
        .previewLayout(.sizeThatFits)
    }

}

