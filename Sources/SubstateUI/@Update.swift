import SwiftUI
import Substate

@propertyWrapper public struct Update: DynamicProperty {

    @EnvironmentObject var store: Store

    public init() {}

    public var wrappedValue: (Action) -> Void {
        get { store.update }
    }

}
