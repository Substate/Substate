import SwiftUI
import SubstateUI

struct CounterView: View {

    let font = Font
        .system(.largeTitle, design: .rounded)
        .weight(.bold)
        .monospacedDigit()

    var body: some View {
        Counter.map { counter in
            VStack(spacing: 24) {
                Text(String(counter.value))

                HStack {
                    Counter.Decrement().map { decrement in
                        Button(action: decrement) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.green)
                                .accessibility(label: Text("Decrement"))
                        }
                        .disabled(!counter.canDecrement)
                    }

                    Counter.Reset().map { reset in
                        Button(action: reset) {
                            Image(systemName: "trash.circle.fill")
                                .foregroundColor(.red)
                                .accessibility(label: Text("Reset"))
                        }
                        .disabled(!counter.canReset)
                    }

                    Counter.Increment().map { increment in
                        Button(action: increment) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .accessibility(label: Text("Increment"))
                        }
                        .disabled(!counter.canIncrement)
                    }
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
            CounterView().model(Counter.zero)
            CounterView().model(Counter.random)
            CounterView().model(Counter.max)
        }
        .previewLayout(.sizeThatFits)
    }

}
