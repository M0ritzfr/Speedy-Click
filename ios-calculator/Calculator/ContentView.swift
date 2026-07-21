import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CalculatorViewModel()

    /// Das klassische Tastenlayout in vier Spalten.
    private let rows: [[CalculatorButton]] = [
        [.clear, .sign, .percent, .operation(.divide)],
        [.digit(7), .digit(8), .digit(9), .operation(.multiply)],
        [.digit(4), .digit(5), .digit(6), .operation(.subtract)],
        [.digit(1), .digit(2), .digit(3), .operation(.add)],
        [.digit(0), .dot, .equals]
    ]

    var body: some View {
        GeometryReader { geometry in
            let spacing = geometry.size.width * 0.03
            // Vier Spalten plus die Zwischenräume füllen die Breite (mit Rändern).
            let horizontalPadding = spacing
            let available = geometry.size.width - horizontalPadding * 2
            let buttonSize = (available - spacing * 3) / 4

            VStack(spacing: spacing) {
                Spacer(minLength: 0)

                // Display
                HStack {
                    Spacer(minLength: 0)
                    Text(viewModel.display)
                        .font(.system(size: buttonSize * 0.7, weight: .light))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                        .padding(.horizontal, spacing)
                }
                .padding(.bottom, spacing)

                // Tastenraster
                ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                    HStack(spacing: spacing) {
                        ForEach(row, id: \.self) { button in
                            CalculatorButtonView(
                                button: button,
                                label: label(for: button),
                                size: buttonSize,
                                spacing: spacing,
                                isActive: isActive(button),
                                action: { viewModel.tap(button) }
                            )
                        }
                        // Zeile mit der breiten "0" ist linksbündig.
                        if row.contains(where: { $0.isWide }) {
                            Spacer(minLength: 0)
                        }
                    }
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.bottom, spacing)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .background(Color.black.ignoresSafeArea())
    }

    private func label(for button: CalculatorButton) -> String {
        if case .clear = button { return viewModel.clearLabel }
        return button.title
    }

    private func isActive(_ button: CalculatorButton) -> Bool {
        if case .operation(let op) = button {
            return viewModel.activeOperation == op
        }
        return false
    }
}

#Preview {
    ContentView()
}
