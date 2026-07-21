import Foundation

/// Reine Rechenlogik des Taschenrechners – ohne UI-Abhängigkeit, damit sie
/// leicht per Unit-Test abgedeckt werden kann. Verhält sich wie der
/// iOS-System-Taschenrechner (verkettete Operationen, AC→C, ± , % usw.).
struct CalculatorEngine {

    /// Die vier Grundrechenarten.
    enum Operation: CaseIterable {
        case add, subtract, multiply, divide

        /// Symbol für die Anzeige auf der Taste.
        var symbol: String {
            switch self {
            case .add:      return "+"
            case .subtract: return "−"
            case .multiply: return "×"
            case .divide:   return "÷"
            }
        }

        func apply(_ lhs: Double, _ rhs: Double) -> Double? {
            switch self {
            case .add:      return lhs + rhs
            case .subtract: return lhs - rhs
            case .multiply: return lhs * rhs
            case .divide:   return rhs == 0 ? nil : lhs / rhs
            }
        }
    }

    // MARK: - Interner Zustand

    /// Der aktuell angezeigte Text (z. B. "0", "12.5" oder "Fehler").
    private(set) var display: String = "0"

    /// Gemerkter linker Operand für eine ausstehende Operation.
    private var storedValue: Double?

    /// Die ausstehende Operation, falls vorhanden.
    private var pendingOperation: Operation?

    /// True, sobald das Display ein Ergebnis/Operanden zeigt und die nächste
    /// Ziffer eine frische Eingabe beginnen soll.
    private var isEnteringNewNumber: Bool = true

    /// True, wenn der Rechner sich in einem Fehlerzustand befindet
    /// (z. B. Division durch Null). Nur `clear()` verlässt ihn.
    private var isError: Bool = false

    /// Welche Operation gerade aktiv/hervorgehoben ist (für die UI).
    var activeOperation: Operation? { pendingOperation }

    /// True, wenn nichts eingegeben wurde (Display "0") → Taste zeigt "AC",
    /// sonst "C".
    var isClearState: Bool {
        display == "0" && storedValue == nil && pendingOperation == nil
    }

    /// Maximale Anzahl signifikanter Stellen in der Anzeige.
    private let maxDigits = 9

    // MARK: - Eingaben

    mutating func inputDigit(_ digit: Int) {
        guard (0...9).contains(digit) else { return }
        if isError { clear() }

        if isEnteringNewNumber {
            display = String(digit)
            isEnteringNewNumber = false
        } else {
            // Ziffernbegrenzung: bestehende Ziffern (ohne '-', '.') zählen.
            let digitCount = display.filter { $0.isNumber }.count
            guard digitCount < maxDigits else { return }
            display = display == "0" ? String(digit) : display + String(digit)
        }
    }

    mutating func inputDot() {
        if isError { clear() }

        if isEnteringNewNumber {
            display = "0."
            isEnteringNewNumber = false
        } else if !display.contains(".") {
            display += "."
        }
    }

    // MARK: - Operationen

    mutating func setOperation(_ operation: Operation) {
        guard !isError else { return }

        // Verkettung: liegt bereits eine Operation samt frisch eingegebenem
        // Operanden vor, wird sie zuerst ausgewertet.
        if pendingOperation != nil && !isEnteringNewNumber {
            calculate()
            if isError { return }
        }

        storedValue = currentValue
        pendingOperation = operation
        isEnteringNewNumber = true
    }

    mutating func equals() {
        guard !isError else { return }
        calculate()
        // Nach '=' ist die Operation abgeschlossen.
        pendingOperation = nil
        storedValue = nil
        isEnteringNewNumber = true
    }

    mutating func clear() {
        display = "0"
        storedValue = nil
        pendingOperation = nil
        isEnteringNewNumber = true
        isError = false
    }

    mutating func toggleSign() {
        guard !isError, currentValue != 0 else { return }
        if display.hasPrefix("-") {
            display.removeFirst()
        } else {
            display = "-" + display
        }
    }

    mutating func percent() {
        guard !isError else { return }
        setDisplay(currentValue / 100)
        isEnteringNewNumber = true
    }

    // MARK: - Hilfsfunktionen

    /// Der numerische Wert der aktuellen Anzeige.
    private var currentValue: Double {
        Double(display) ?? 0
    }

    /// Führt die ausstehende Operation mit gemerktem und aktuellem Wert aus.
    private mutating func calculate() {
        guard let operation = pendingOperation, let lhs = storedValue else { return }
        let rhs = currentValue
        guard let result = operation.apply(lhs, rhs) else {
            setError()
            return
        }
        setDisplay(result)
    }

    private mutating func setError() {
        display = "Fehler"
        storedValue = nil
        pendingOperation = nil
        isEnteringNewNumber = true
        isError = true
    }

    /// Formatiert einen Double sauber für die Anzeige (ganze Zahlen ohne
    /// Nachkommastellen, sonst gerundet, Exponent bei sehr großen Werten).
    private mutating func setDisplay(_ value: Double) {
        if value.isNaN || value.isInfinite {
            setError()
            return
        }
        display = CalculatorEngine.format(value, maxDigits: maxDigits)
    }

    /// Formatiert einen Wert für die Anzeige mit begrenzter Stellenzahl.
    static func format(_ value: Double, maxDigits: Int) -> String {
        // Ganzzahlige Werte ohne Dezimalpunkt, sofern sie in die Stellenzahl passen.
        if value == value.rounded() && abs(value) < pow(10.0, Double(maxDigits)) {
            return String(format: "%.0f", value)
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.decimalSeparator = "."
        formatter.maximumSignificantDigits = maxDigits
        formatter.minimumSignificantDigits = 1

        if let formatted = formatter.string(from: NSNumber(value: value)) {
            return formatted
        }
        return String(value)
    }
}
