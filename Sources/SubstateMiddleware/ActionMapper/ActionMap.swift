public struct ActionMap {

     let items: [ActionMapItem]

    public init(items: [ActionMapItem]) {
        self.items = items
    }

    public init(@ActionMapItemListBuilder items: () -> [ActionMapItem]) {
        self.items = items()
    }

    @available(macOS 10.15, iOS 13, *)
    @resultBuilder public struct ActionMapItemListBuilder {
        public static func buildBlock(_ items: ActionMapItem...) -> [ActionMapItem] { items }
    }

}
