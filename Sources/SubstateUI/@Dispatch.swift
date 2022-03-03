import SwiftUI
import Substate

@propertyWrapper public struct Dispatch: DynamicProperty {

    private let action: Action
    @EnvironmentObject var store: Store

    public init(_ action: @autoclosure @escaping () -> Action) {
        self.action = action()
    }

    public var wrappedValue: () -> Void {
        get { { store.dispatch(action) } }
    }

}
