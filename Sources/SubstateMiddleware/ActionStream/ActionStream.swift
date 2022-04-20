import Combine
import Substate

@MainActor public class ActionStream {

    var store: Store? = nil
    let publisher = PassthroughSubject<Action, Never>()

    private var subscriptions: [AnyCancellable] = []

    public init(@Builder items: (ActionStream) -> [Builder.Item]) {
        self.subscriptions = items(self).map { item in item(self) }
    }

}
