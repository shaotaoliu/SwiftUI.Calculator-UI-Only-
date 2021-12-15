import SwiftUI

enum CalculatorButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case decimal = "."
    case add = "+"
    case subtract = "–"
    case mutliply = "x"
    case divide = "÷"
    case equal = "="
    case clear = "AC"
    case negative = "-/+"
    case percent = "%"
    
    var foregroundColor: Color {
        switch self {
        case .clear, .negative, .percent:
            return .black
        default:
            return .white
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .add, .subtract, .mutliply, .divide, .equal:
            return .orange
        case .clear, .negative, .percent:
            return Color(.lightGray)
        default:
            return Color(.darkGray)
        }
    }
    
    func `in`(_ buttons: [CalculatorButton]) -> Bool {
        for button in buttons {
            if button == self {
                return true
            }
        }
        return false
    }
}
