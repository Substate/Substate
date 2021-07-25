import SwiftUI
import Substate

@propertyWrapper public struct Model<Type:Substate.Model>: DynamicProperty {

    @EnvironmentObject var store: Store

    public init() {}
    
    public var wrappedValue: Type {
        get {
            guard let model = store.find(Type.self) else {
                preconditionFailure("Substate model \"\(Type.self)\" is missing!")
            }

            return model
        }
    }

}
