import Substate
import Combine


public struct ActionPlan {

    init(@Builder streams: () -> [AnyPublisher<Action, Never>]) {
        fatalError()
    }

    let streams: [AnyPublisher<Action, Never>]

    struct DummyModel: Model { mutating func update(action: Action) {} }

    @MainActor
    init<M1:Model>(_ m1: M1.Type, @Builder streams: @MainActor (ModelProxy<M1>) -> [AnyPublisher<Action, Never>]) {
        // How would we really get the store here?
        // We’d need to pass it in just like ActionTrigger currently does.
        let store = Store(model: DummyModel())
        self.streams = streams(ModelProxy(type: m1, getter: { store.find(M1.self) }))
    }

    @resultBuilder public struct Builder {
//        public static func buildExpression(_ expression: Stream) -> [ActionPlan.Stream] {
//            [expression as Stream]
//        }
        public static func buildBlock(_ streams: AnyPublisher<Action, Never>...) -> [AnyPublisher<Action, Never>] {
            streams

            
        }

        public static func buildBlock<M1:Model>(_ m1: ModelProxy<M1>, _ streams: AnyPublisher<Action, Never>...) -> [AnyPublisher<Action, Never>] {
            streams
        }
    }

    func find<M:Model>(type: M.Type) -> M? {
        fatalError() // Here we’d somehow get the model from the store
    }

    @dynamicMemberLookup
    public class ModelProxy<M:Model> {
        let getter: () -> M?

        init(type: M.Type, getter: @escaping () -> M?) {
            self.getter = getter
        }

        subscript<T>(dynamicMember keyPath: KeyPath<M, T>) -> T {
            let model = getter()
            assert(model != nil, "Model of type \(String(describing: M.self)) not present in store!")
            return model![keyPath: keyPath]
        }
    }

}

extension Action {
    static func subscribe() -> AnyPublisher<Action, Never> {
        fatalError()
    }
}
