import SwiftUI
import Substate

public protocol ModelView: View {
    associatedtype Model: Substate.State
    associatedtype ViewType: View

    func body(model: Model) -> ViewType
}

public extension ModelView {
    var body: some View {
        Model.map { state in
            body(model: state)
        }
    }
}
