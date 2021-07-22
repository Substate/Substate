import SwiftUI
import SubstateUI

struct CounterView: View {

    let font = Font
        .system(.largeTitle, design: .rounded)
        .weight(.bold)
        .monospacedDigit()

    var body: some View {
        Select(Counter.self) { counter, update in
            VStack(spacing: 24) {
                Text(String(counter.value))

                HStack {
                    Button(action: { update(Counter.Decrement()) }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.green)
                            .accessibility(label: Text("Decrement"))
                    }
                    .disabled(!counter.canDecrement)

                    Button(action: { update(Counter.Reset()) }) {
                        Image(systemName: "trash.circle.fill")
                            .foregroundColor(.red)
                            .accessibility(label: Text("Reset"))
                    }
                    .disabled(!counter.canReset)

                    Button(action: { update(Counter.Increment()) }) {
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

}

struct CounterViewPreviews: PreviewProvider {

    static var previews: some View {
        Group {
            // Xcode bug causing crash with multiple views?
            // Problem with the way .state() is implemented?

            // CounterView().state(Counter.zero)
            CounterView().state(Counter.random)
            // CounterView().state(Counter.max)
        }
        .previewLayout(.sizeThatFits)
    }

}
