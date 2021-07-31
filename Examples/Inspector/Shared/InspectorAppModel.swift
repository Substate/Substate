import Foundation
import Substate

struct InspectorAppModel: Model {
    var stream = EventStream()
    var toolbar = Toolbar()

    mutating func update(action: Action) {}
}

extension InspectorAppModel {
    static let sample = InspectorAppModel(stream: .sample)
}
