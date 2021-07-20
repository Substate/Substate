Store

- Optimise state selection by computing a full tree on init
- Provide some kind of helper on the store to create bindings for SwiftUI that take a setter action
- Remove dependency on the Runtime library
- Provide some way for middleware to get the root state, and a list of all substates, as well as exposing the .state(type) method

Middleware

- Comprehensive and library-appropriate internal logging
  - Could Use signposts to benchmark the reduce time. Or make a middleware for that
  - Would be cool to have a middle ware to be able to benchmark specific actions or the whole reduce

- Middleware that runs a server and enables a client 'substate inspector' type companion app

- Middleware which provides a list of all actions called for testing, with some nice method to test if a certain action with certain data was sent
  - eg: actionCatcher.find(Counter.Reset.self) -> [Counter.Reset]
  - eg: actionCatcher.find(Counter.Reset.self).contains { $0.toValue == 3 }
