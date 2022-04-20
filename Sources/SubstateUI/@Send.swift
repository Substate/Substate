import SwiftUI
import Substate

@propertyWrapper public struct Send: DynamicProperty {

    @EnvironmentObject var store: Store

    public init() {}

    public var wrappedValue: (Action) -> Void {
        { action in store.dispatch(action) }
    }

}
