import SwiftUI
import Substate

@propertyWrapper public struct Send: DynamicProperty {

    @EnvironmentObject var store: Store

    public init() {}

    public var wrappedValue: Substate.Send {
        get { store.send }
    }

}
