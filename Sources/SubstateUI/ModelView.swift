import SwiftUI
import Substate

public protocol ModelView: View {

    associatedtype Model: Substate.Model
    associatedtype ViewType: View

    func body(model: Model, update: @escaping Update) -> ViewType

}

public extension ModelView {

    var body: some View {
        Model.map(body)
    }

}
