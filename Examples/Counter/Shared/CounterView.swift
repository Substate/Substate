import SwiftUI
import SubstateUI
import SubstateMiddleware
import Combine

struct CounterView: View {

    @Send var send
    @Model var counter: Counter

    let font = Font
        .system(.largeTitle, design: .rounded)
        .weight(.bold)
        .monospacedDigit()

    var body: some View {
        VStack(spacing: 24) {
            Text(String(counter.value))

            HStack {
                Button(action: send(Counter.Decrement())) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.green)
                        .accessibility(label: Text("Decrement"))
                }
                .disabled(!counter.canDecrement)

                Button(action: send(Counter.Reset())) {
                    Image(systemName: "trash.circle.fill")
                        .foregroundColor(.red)
                        .accessibility(label: Text("Reset"))
                }
                .disabled(!counter.canReset)

                Button(action: send(Counter.Increment())) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                        .accessibility(label: Text("Increment"))
                }
                .disabled(!counter.canIncrement)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .font(font)
        .padding()
        .frame(minWidth: 300, minHeight: 200)
    }

}

struct CounterViewPreviews: PreviewProvider {

    static var previews: some View {
        Group {
            CounterView().model(Counter.zero)
            CounterView().model(Counter.random)
            CounterView().model(Counter.max)
        }
        .previewLayout(.sizeThatFits)
    }

}
