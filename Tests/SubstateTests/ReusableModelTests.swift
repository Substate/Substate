import XCTest
import Substate

/// Reusable models is a pattern where models are made generic and 'tagged' with a parent type in
/// order to be identified and updated separately.
///
/// This setup has the advantage of providing multiple free instance-specific actions too, as long
/// as the actions are nested within the model.
///
final class ReusableModelTests: XCTestCase {

    struct Pager<Parent>: Model {
        var page = 1

        struct Next: Action {}

        mutating func update(action: Action) {
            if action is Next {
                page += 1
            }
        }
    }

    struct NewsScreen: Model {
        var pager = Pager<NewsScreen>()

        mutating func update(action: Action) {}
    }

    struct ProductsScreen: Model {
        var pager = Pager<ProductsScreen>()

        mutating func update(action: Action) {}
    }

    struct AppModel: Model {
        var newsScreen = NewsScreen()
        var productsScreen = ProductsScreen()

        mutating func update(action: Action) {}
    }

    func testInitialState() throws {
        let store = Store(model: AppModel())

        XCTAssertEqual(store.find(Pager<NewsScreen>.self)?.page, 1)
        XCTAssertEqual(store.find(Pager<ProductsScreen>.self)?.page, 1)
    }

    func testFirstChildUpdates() throws {
        let store = Store(model: AppModel())
        store.update(Pager<NewsScreen>.Next())

        XCTAssertEqual(store.find(Pager<NewsScreen>.self)?.page, 2)
        XCTAssertEqual(store.find(Pager<ProductsScreen>.self)?.page, 1)
    }

    func testSecondChildUpdates() throws {
        let store = Store(model: AppModel())
        store.update(Pager<ProductsScreen>.Next())

        XCTAssertEqual(store.find(Pager<NewsScreen>.self)?.page, 1)
        XCTAssertEqual(store.find(Pager<ProductsScreen>.self)?.page, 2)
    }

}
