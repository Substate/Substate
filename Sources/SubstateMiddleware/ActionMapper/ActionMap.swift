public struct ActionMap {

     let items: [ActionMapItem]

    public init(items: [ActionMapItem]) {
        self.items = items
    }

    public init(@ActionMapItemListBuilder items: () -> [ActionMapItem]) {
        self.items = items()
    }

    @available(swift 5.4)
    @resultBuilder public struct ActionMapItemListBuilder {
        public static func buildBlock(_ items: ActionMapItem...) -> [ActionMapItem] { items }
    }

}
