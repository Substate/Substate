public struct ActionMap {

    let items: [ActionMapItem]

    public init(items: [ActionMapItem]) {
        self.items = items
    }

#if compiler(>=5.4)
    public init(@ActionMapItemListBuilder items: () -> [ActionMapItem]) {
        self.items = items()
    }
#endif

#if compiler(>=5.4)
    @resultBuilder public struct ActionMapItemListBuilder {
        public static func buildBlock(_ items: ActionMapItem...) -> [ActionMapItem] { items }
    }
#endif

}
