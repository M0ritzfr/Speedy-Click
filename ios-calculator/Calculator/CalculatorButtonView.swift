import SwiftUI

/// Alle Tasten des Taschenrechners.
enum CalculatorButton: Hashable {
    case digit(Int)
    case dot
    case operation(CalculatorEngine.Operation)
    case equals
    case clear
    case sign
    case percent

    /// Beschriftung der Taste (der Clear-Text AC/C wird in der View überschrieben).
    var title: String {
        switch self {
        case .digit(let value):     return String(value)
        case .dot:                  return "."
        case .operation(let op):    return op.symbol
        case .equals:               return "="
        case .clear:                return "AC"
        case .sign:                 return "±"
        case .percent:              return "%"
        }
    }

    /// Grundfarbe der Taste – angelehnt an den iOS-System-Taschenrechner.
    var tint: CalculatorButton.Tint {
        switch self {
        case .operation, .equals:
            return .accent          // orange
        case .clear, .sign, .percent:
            return .function        // hellgrau
        default:
            return .digit           // dunkelgrau
        }
    }

    /// Ob die Taste doppelt breit dargestellt wird (die "0").
    var isWide: Bool {
        if case .digit(0) = self { return true }
        return false
    }

    enum Tint {
        case digit, function, accent

        var background: Color {
            switch self {
            case .digit:    return Color(white: 0.20)
            case .function: return Color(white: 0.65)
            case .accent:   return Color(red: 1.0, green: 0.62, blue: 0.04)
            }
        }

        var foreground: Color {
            switch self {
            case .function: return .black
            default:        return .white
            }
        }
    }
}

/// Eine einzelne, runde Taschenrechner-Taste.
struct CalculatorButtonView: View {
    let button: CalculatorButton
    let label: String
    let size: CGFloat
    let spacing: CGFloat
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: size * 0.4, weight: .regular))
                .foregroundColor(foreground)
                .frame(width: width, height: size)
                .background(background)
                .clipShape(Capsule())
        }
        .buttonStyle(PressableButtonStyle())
    }

    // Die "0" belegt zwei Spalten plus den Zwischenraum.
    private var width: CGFloat {
        button.isWide ? size * 2 + spacing : size
    }

    // Aktive Operator-Taste wird invertiert dargestellt (weiß auf orange → orange auf weiß).
    private var background: Color {
        isActive ? .white : button.tint.background
    }

    private var foreground: Color {
        isActive ? button.tint.background : button.tint.foreground
    }
}

/// Leichtes Aufblitzen/Verkleinern beim Drücken.
private struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
