import Foundation
import SwiftUI

/// Dünner Adapter zwischen der reinen `CalculatorEngine` und der SwiftUI-View.
/// Hält die Engine und reicht Tastendrücke weiter; `@Published`-Properties
/// treiben die UI-Aktualisierung.
final class CalculatorViewModel: ObservableObject {

    @Published private var engine = CalculatorEngine()

    /// Der anzuzeigende Text im Display.
    var display: String { engine.display }

    /// Beschriftung der Clear-Taste: "AC" im Ausgangszustand, sonst "C".
    var clearLabel: String { engine.isClearState ? "AC" : "C" }

    /// Die aktuell hervorgehobene Operation (für die Taste im aktiven Zustand).
    var activeOperation: CalculatorEngine.Operation? { engine.activeOperation }

    // MARK: - Tastendrücke

    func tap(_ button: CalculatorButton) {
        switch button {
        case .digit(let value):
            engine.inputDigit(value)
        case .dot:
            engine.inputDot()
        case .operation(let op):
            engine.setOperation(op)
        case .equals:
            engine.equals()
        case .clear:
            engine.clear()
        case .sign:
            engine.toggleSign()
        case .percent:
            engine.percent()
        }
    }
}
