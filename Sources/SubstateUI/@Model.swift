import SwiftUI
import Substate

@propertyWrapper public struct Model<V>: DynamicProperty where V: Substate.Model {

    let action: ((V) -> Substate.Action)?
    @EnvironmentObject var store: Store

    public init() {
        self.action = nil
    }

    public init(_ action: @escaping (V) -> Substate.Action) {
        self.action = action
    }

    public var wrappedValue: V {
        get {
            guard let model = store.find(V.self) else {
                preconditionFailure("Substate model \"\(V.self)\" is missing!")
            }

            return model
        }

        nonmutating set {
            if let action = action {
                store.send(action(newValue))
            } else {
                store.send(Store.Replace(model: newValue))
            }
        }
    }

    public var projectedValue: Binding<V> {
        .init( get: { wrappedValue }, set: { wrappedValue = $0 } )
    }

}

/// TODO: Tidy up and split out
///
@propertyWrapper public struct Value<M, V>: DynamicProperty where M: Substate.Model {

    let action: ((V) -> Substate.Action)?
    let keyPath: WritableKeyPath<M, V>

    @EnvironmentObject var store: Store

    public init(_ keyPath: WritableKeyPath<M, V>) {
        self.keyPath = keyPath
        self.action = nil
    }

    public init(_ keyPath: WritableKeyPath<M, V>, _ action: @escaping (V) -> Substate.Action) {
        self.keyPath = keyPath
        self.action = action
    }

    public var wrappedValue: V {
        get {
            guard let model = store.find(M.self) else {
                preconditionFailure("Substate model \"\(M.self)\" is missing!")
            }

            return model[keyPath: keyPath]
        }

        nonmutating set {
            guard var model = store.find(M.self) else {
                preconditionFailure("Substate model \"\(M.self)\" is missing!")
            }

            model[keyPath: keyPath] = newValue

            if let action = action {
                store.send(action(newValue))
            } else {
                store.send(Store.Replace(model: model))
            }
        }
    }

    public var projectedValue: Binding<V> {
        .init( get: { wrappedValue }, set: { wrappedValue = $0 } )
    }

}

