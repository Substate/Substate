import SwiftUI
import Substate

struct MissingModelView<StateType:Substate.Model>: View {

    let type: StateType.Type

    var body: some View {
        Label(message, systemImage: "exclamationmark.triangle.fill")
            .font(.system(.caption, design: .rounded).weight(.bold))
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .foregroundColor(.white)
            .background(Color.orange)
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    var message: String {
        "Missing Model: \(String(describing: type))"
    }

}

struct MissingModelViewPreviews: PreviewProvider {

    struct ToolbarTestModel: Substate.Model {
        func update(action: Action) {}
    }

    static var previews: some View {
        MissingModelView(type: ToolbarTestModel.self)
            .padding()
            .previewLayout(.sizeThatFits)
    }

}
