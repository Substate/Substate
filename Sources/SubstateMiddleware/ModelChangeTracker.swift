import Substate

/// There’s a few interesting things we could do here.
///
/// Could do a straightforward model diffing routine, providing actions in the form of:
/// - ModelDidChange<TaskList>
///
/// Although, would we be able to fully use generics in the actions here if we’re generating them
/// dynamically? Or would it have to be a single ModelDidChange action with a property for the type?
///
/// ---
///
/// And/or, we could do something clever with action namespacing.
///
/// If the app’s actions are all (or mainly) namespaced under their models, we could try and
/// detect that by matching the module and module name from reflection metadata to the incoming
/// action type. We could detect if actions relating to 'this model' were called.
///
/// This might be more interesting/appropriate than just doing tons of diffing?
///
/// - ModelActionDidFire<TaskList, Create>
///
/// - eg. AnyModelAction<TaskList>.map(\TaskList.all.count, to: Titlebar.UpdateCount.init)
///
/// ---
///
/// 'ChangeTrackedModel' to define which models to watch?
///
/// ---
///
/// Is any of the generic actions stuff actually possible given at some point all models will
/// lose their type information (because they’re stored in [Model] at some point)?
///
