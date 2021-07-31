import SwiftUI
import Substate
import SubstateUI
import SubstateMiddleware
import Swifter

let server = Server()
let store = Store(model: InspectorAppModel(), middleware: [ActionLogger()])

@main struct InspectorApp: App {

    var body: some Scene {
        WindowGroup {
            InspectorAppView()
                .environmentObject(store)
                .onAppear { server.start() }
        }
    }

}

class Server {
    let server = HttpServer()

    init() {
        server.POST["/"] = { request in
            if let entry = try? JSONDecoder().decode(LogEntry.self, from: Data(request.body)) {
                DispatchQueue.main.async {
                    store.update(EventStream.Add(event: Event(id: .init(), date: entry.date, type: entry.type, components: entry.components)))
                }
            }

            return .ok(.htmlBody("Request Processed"))
        }
    }

    func start() {
        try! server.start(3000)
    }
}
