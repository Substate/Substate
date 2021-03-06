import SwiftUI
import SubstateUI
import SubstateMiddleware
import Combine

struct CounterView: View {

    @Model var counter: Counter

    @Dispatch(Counter.Reset()) var reset
    @Dispatch(Counter.Increment()) var increment
    @Dispatch(Counter.Decrement()) var decrement

    let font = Font
        .system(.largeTitle, design: .rounded)
        .weight(.bold)
        .monospacedDigit()

    var body: some View {
        VStack(spacing: 24) {
            Text(String(counter.value))

            HStack {
                Button(action: decrement) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.green)
                        .accessibility(label: Text("Decrement"))
                }
                .disabled(!counter.canDecrement)

                Button(action: reset) {
                    Image(systemName: "trash.circle.fill")
                        .foregroundColor(.red)
                        .accessibility(label: Text("Reset"))
                }
                .disabled(!counter.canReset)

                Button(action: increment) {
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
