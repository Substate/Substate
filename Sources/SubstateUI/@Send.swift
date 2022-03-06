import SwiftUI
import Substate

@propertyWrapper public struct Send: DynamicProperty {

    @EnvironmentObject var store: Store

    public init() {}

    public var wrappedValue: (Action) -> Void {
        get { { action in Task { try await store.dispatch(action) } } }
    }

}
