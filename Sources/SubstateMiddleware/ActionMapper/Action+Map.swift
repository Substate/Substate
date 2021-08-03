//import Substate
//
///// All versions of the Action.map method.
/////
///// - eg. MyAction.map(\.someValue, \MyModel.otherValue, to: AnotherAction.init(a:b:))
/////
///// - We include a range of combinations here, up to 3 arguments
///// - There are other combination not covered (eg. action property + model + model property)
///// - Can add more if needed, but variadic generics may arrive before then anyway
/////
///// - TODO: The versions that select a property should all allow the property to be optional!
/////
//extension Action {
//
//    /// 1. Mapping to a constant action.
//    ///
//    /// - Action1.map(to: Action2(value: 123))
//    ///
//    public static func map<A2>(to output: @autoclosure @escaping () -> A2?) -> ActionMapItem where A2: Action {
//        return { action, find in
//            return action is Self ? output() : nil
//        }
//    }
//
//    /// 2. Mapping to a function taking no parameters.
//    ///
//    /// - Action1.map(to: Action2.init)
//    /// - Action1.map { Action2() }
//    ///
//    public static func map<A2>(to output: @escaping () -> A2?) -> ActionMapItem where A2: Action {
//        return { action, find in
//            return action is Self ? output() : nil
//        }
//    }
//
//    /// 3. Mapping the action itself.
//    ///
//    /// - Action1.map(to: Action2.init(action:))
//    /// - Action1.map { action in Action2(action: action) }
//    ///
//    public static func map<A2>(to output: @escaping (Self) -> A2?) -> ActionMapItem where A2: Action {
//        return { action, find in
//            if let action = action as? Self {
//                return output(action)
//            } else {
//                return nil
//            }
//        }
//    }
//
//    /// 4a. Mapping one or more action properties.
//    ///
//    /// - Action1.map(\.value, to: Action2.init(value:))
//    /// - Action1.map(\.value) { value in Action2(value: value) }
//    ///
//    public static func map<V1, A2>(_ value: KeyPath<Self, V1>, to output: @escaping (V1) -> A2?) -> ActionMapItem where A2: Action {
//        return { action, find in
//            if let action = action as? Self {
//                return output(action[keyPath: value])
//            } else {
//                return nil
//            }
//        }
//    }
//
//    /// 4b. 2 properties.
//    ///
//    /// - Action1.map(\.value, \.value2, to: Action2.init(value:value2:))
//    ///
//    public static func map<V1, V2, A2>(_ value: KeyPath<Self, V1>, _ value2: KeyPath<Self, V2>, to output: @escaping (V1, V2) -> A2?) -> ActionMapItem where A2: Action {
//        return { action, find in
//            if let action = action as? Self {
//                return output(action[keyPath: value], action[keyPath: value2])
//            } else {
//                return nil
//            }
//        }
//    }
//
//    /// 4c. 3 properties.
//    ///
//    /// - Action1.map(\.value, \.value2, \.value3, to: Action2.init(value:value2:value3:))
//    ///
//    public static func map<V1, V2, V3, A2>(_ value: KeyPath<Self, V1>, _ value2: KeyPath<Self, V2>, _ value3: KeyPath<Self, V3>, to output: @escaping (V1, V2, V3) -> A2?) -> ActionMapItem where A2: Action {
//        return { action, find in
//            if let action = action as? Self {
//                return output(action[keyPath: value], action[keyPath: value2], action[keyPath: value3])
//            } else {
//                return nil
//            }
//        }
//    }
//
//    /// 5a. Mapping one or more models.
//    ///
//    /// - Action1.map(Model1.self, to: Action2.init(model:))
//    /// - Action1.map(Model1.self) { model in Action2(model: model) }
//    ///
//    public static func map<M1, A2>(_ value: M1.Type, to output: @escaping (M1) -> A2?) -> ActionMapItem where A2: Action, M1: Model {
//        return { action, find in
//            if action is Self, let model = find(M1.self) as? M1 {
//                return output(model)
//            } else {
//                return nil
//            }
//        }
//    }
//
//    /// 5b. 2 models.
//    ///
//    /// - Action1.map(Model1.self, Model2.self, to: Action2.init(model1:model2))
//    ///
//    public static func map<M1, M2, A2>(_ value: M1.Type, _ value2: M2.Type, to output: @escaping (M1, M2) -> A2?) -> ActionMapItem where A2: Action, M1: Model, M2: Model {
//        return { action, find in
//            if action is Self,
//               let model1 = find(M1.self) as? M1,
//               let model2 = find(M2.self) as? M2 {
//                return output(model1, model2)
//            } else {
//                return nil
//            }
//        }
//    }
//
//    /// 5c. 3 models.
//    ///
//    /// - Action1.map(Model1.self, Model2.self, Model3.self, to: Action2.init(model1:model2:model3))
//    ///
//    public static func map<M1, M2, M3, A2>(_ value: M1.Type, _ value2: M2.Type, _ value3: M3.Type, to output: @escaping (M1, M2, M3) -> A2?) -> ActionMapItem where A2: Action, M1: Model, M2: Model, M3: Model {
//        return { action, find in
//            if action is Self,
//               let model1 = find(M1.self) as? M1,
//               let model2 = find(M2.self) as? M2,
//               let model3 = find(M3.self) as? M3 {
//                return output(model1, model2, model3)
//            } else {
//                return nil
//            }
//        }
//    }
//
//    /// 6a. Mapping one or more model properties.
//    ///
//    /// - Action1.map(\Model1.value, to: Action2.init(value:))
//    /// - Action1.map(\Model1.value) { value in Action2(value: value) }
//    ///
//    public static func map<M1, V1, A2>(_ value: KeyPath<M1, V1>, to output: @escaping (V1) -> A2?) -> ActionMapItem where A2: Action, M1: Model {
//        return { action, find in
//            if action is Self,
//               let model = find(M1.self) as? M1 {
//                return output(model[keyPath: value])
//            } else {
//                return nil
//            }
//        }
//    }
//
//    /// 6b. 2 model properties.
//    ///
//    /// - Action1.map(\Model1.value, \Model2.value, to: Action2.init(value1:value2:))
//    ///
//    public static func map<M1, V1, M2, V2, A2>(_ value: KeyPath<M1, V1>, _ value2: KeyPath<M2, V2>, to output: @escaping (V1, V2) -> A2?) -> ActionMapItem where A2: Action, M1: Model, M2: Model {
//        return { action, find in
//            if action is Self,
//               let model1 = find(M1.self) as? M1,
//               let model2 = find(M2.self) as? M2 {
//                return output(model1[keyPath: value], model2[keyPath: value2])
//            } else {
//                return nil
//            }
//        }
//    }
//
//    /// 6c. 3 model properties.
//    ///
//    /// - Action1.map(\Model1.value, \Model2.value, \Model3.value, to: Action2.init(value1:value2:value3:))
//    ///
//    public static func map<M1, V1, M2, V2, M3, V3, A2>(_ value: KeyPath<M1, V1>, _ value2: KeyPath<M2, V2>, _ value3: KeyPath<M3, V3>, to output: @escaping (V1, V2, V3) -> A2?) -> ActionMapItem where A2: Action, M1: Model, M2: Model, M3: Model {
//        return { action, find in
//            if action is Self,
//               let model1 = find(M1.self) as? M1,
//               let model2 = find(M2.self) as? M2,
//               let model3 = find(M3.self) as? M3 {
//                return output(model1[keyPath: value], model2[keyPath: value2], model3[keyPath: value3])
//            } else {
//                return nil
//            }
//        }
//    }
//
//    /// 7a. Mapping an action property and one or more models.
//    ///
//    /// - Action1.map(\.value, Model1.self, to: Action2(value:model:)
//    /// - Action1.map(\.value, Model1.self) { value, model in Action2(value: value, model: model) }
//    ///
//    public static func map<V1, M1, A2>(_ value: KeyPath<Self, V1>, _ value2: M1.Type, to output: @escaping (V1, M1) -> A2?) -> ActionMapItem where A2: Action, M1: Model {
//        return { action, find in
//            if let action = action as? Self,
//               let model = find(M1.self) as? M1 {
//                return output(action[keyPath: value], model)
//            } else {
//                return nil
//            }
//        }
//    }
//
//    /// 7b. 2 models.
//    ///
//    /// - Action1.map(\.value, Model1.self, Model2.self, to: Action2(value:model1:model2:)
//    ///
//    public static func map<V1, M1, M2, A2>(_ value: KeyPath<Self, V1>, _ value2: M1.Type, _ value3: M2.Type, to output: @escaping (V1, M1, M2) -> A2?) -> ActionMapItem where A2: Action, M1: Model, M2: Model {
//        return { action, find in
//            if let action = action as? Self,
//               let model1 = find(M1.self) as? M1,
//               let model2 = find(M2.self) as? M2 {
//                return output(action[keyPath: value], model1, model2)
//            } else {
//                return nil
//            }
//        }
//    }
//
//
//    /// 8a. Mapping an action property and one or more model properties.
//    ///
//    /// - Action1.map(\.value, \Model1.value, to: Action2(value1:value2:)
//    /// - Action1.map(\.value, \Model1.value) { value1, value2 in Action2(value1: value1, value2: value2) }
//    ///
//    public static func map<V0, M1, V1, A2>(_ value: KeyPath<Self, V0>, _ value2: KeyPath<M1, V1>, to output: @escaping (V0, V1) -> A2?) -> ActionMapItem where A2: Action, M1: Model {
//        return { action, find in
//            if let action = action as? Self,
//               let model = find(M1.self) as? M1 {
//                return output(action[keyPath: value], model[keyPath: value2])
//            } else {
//                return nil
//            }
//        }
//    }
//
//    /// 8b. 2 model properties.
//    ///
//    /// - Action1.map(\.value, \Model1.value, \Model2.value, to: Action2.init(value1:value2:value3:)
//    ///
//    public static func map<V0, M1, V1, M2, V2, A2>(_ value: KeyPath<Self, V0>, _ value2: KeyPath<M1, V1>, _ value3: KeyPath<M2, V2>, to output: @escaping (V0, V1, V2) -> A2?) -> ActionMapItem where A2: Action, M1: Model, M2: Model {
//        return { action, find in
//            if let action = action as? Self,
//               let model1 = find(M1.self) as? M1,
//               let model2 = find(M2.self) as? M2 {
//                return output(action[keyPath: value], model1[keyPath: value2], model2[keyPath: value3])
//            } else {
//                return nil
//            }
//        }
//    }
//
//}
