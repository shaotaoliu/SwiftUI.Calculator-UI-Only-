import SwiftUI

class ViewModel: ObservableObject {
    let buttons: [[CalculatorButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .mutliply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]

    let buttonSpacing: CGFloat = 15
    let buttonFontSize: CGFloat = 32
    let resultFontSize: CGFloat = 72
    let resultForegroundColor = Color.white
    
    @Published var display = "0"
    
    private var firstNumber: Double?
    private var secondNumber: Double?
    private var firstOperator: CalculatorButton?
    private var secondOperator: CalculatorButton?
    private var lastButton: CalculatorButton?
    private let ERROR = "ERROR!"
    
    private let numberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 10
            return formatter
        }()
    
    func tapButton(button: CalculatorButton) {
        if display == ERROR {
            display = "0"
        }
        
        switch button {
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
            if lastButton == nil || lastButton!.in([.add, .subtract, .mutliply, .divide, .equal, .clear]) {
                display = button.rawValue
            }
            else if display == "0" {
                display = button.rawValue
            } else {
                display += button.rawValue
            }
            
        case .decimal:
            if display.contains(".") {
                break
            }
            
            if lastButton == nil || lastButton!.in([.add, .subtract, .mutliply, .divide, .equal, .clear]) {
                display = "0."
            }
            else {
                display += button.rawValue
            }
            
        case .negative:
            if display.first == "-" {
                display.removeFirst()
            } else {
                display = "-\(display)"
            }
            
        case .add, .subtract, .mutliply, .divide:
            if lastButton != nil && lastButton!.in([.add, .subtract, .mutliply, .divide]) {
                if secondOperator != nil {
                    secondOperator = button
                } else {
                    firstOperator = button
                }
                break
            }
            
            guard let current = Double(display) else {
                failed()
                return
            }
            
            if firstOperator == nil {
                firstNumber = current
                firstOperator = button
                break
            }
            
            if secondOperator == nil {
                if button.in([.add, .subtract]) || firstOperator!.in([.mutliply, .divide]) {
                    firstNumber = operate(firstNumber!, current, oper: firstOperator!)
                    display = numberFormatter.string(from: NSNumber(value: firstNumber!))!
                    firstOperator = button
                }
                else {
                    secondNumber = current
                    secondOperator = button
                }
                
                break
            }
            
            secondNumber = operate(secondNumber!, current, oper: secondOperator!)
            display = numberFormatter.string(from: NSNumber(value: secondNumber!))!
            
            secondOperator = nil
            tapButton(button: button)
            
        case .percent:
            if lastButton != nil && lastButton!.in([.add, .subtract, .mutliply, .divide]) {
                if secondOperator != nil {
                    secondOperator = nil
                } else {
                    firstOperator = nil
                }
            }
            
            guard let current = Double(display) else {
                failed()
                return
            }
            
            guard let first = firstOperator else {
                display = numberFormatter.string(from: NSNumber(value: current / 100))!
                break
            }
            
            var oper = first
            var num = firstNumber!
            
            if secondOperator != nil {
                oper = secondOperator!
                num = secondNumber!
            }
            
            var value: Double = 0
            
            if oper.in([.add, .subtract]) {
                value = num * current
            }
            else {
                value = current
            }
            
            display = numberFormatter.string(from: NSNumber(value: value / 100))!
            break
            
        case .equal:
            guard let current = Double(display) else {
                failed()
                return
            }
            
            if firstOperator != nil {
                if secondOperator == nil {
                    if !lastButton!.in([.add, .subtract, .mutliply, .divide]) {
                        let result = operate(firstNumber!, current, oper: firstOperator!)
                        display = numberFormatter.string(from: NSNumber(value: result))!
                    }
                }
                else if lastButton!.in([.add, .subtract, .mutliply, .divide]) {
                    let result = operate(firstNumber!, secondNumber!, oper: firstOperator!)
                    display = numberFormatter.string(from: NSNumber(value: result))!
                }
                else {
                    secondNumber = operate(secondNumber!, current, oper: secondOperator!)
                    let result = operate(firstNumber!, secondNumber!, oper: firstOperator!)
                    display = numberFormatter.string(from: NSNumber(value: result))!
                }
            }
            
            reset()
            
        case .clear:
            reset()
            display = "0"
            break
            
        default:
            break
        }
        
        lastButton = button
    }
    
    func reset() {
        firstNumber = nil
        secondNumber = nil
        firstOperator = nil
        secondOperator = nil
    }
    
    func failed() {
        reset()
        lastButton = nil
        display = ERROR
    }
    
    func operate(_ a: Double, _ b: Double, oper: CalculatorButton) -> Double {
        switch oper {
        case .add:
            return a + b
            
        case .subtract:
            return a - b
            
        case .mutliply:
            return a * b
            
        case .divide:
            return a / b
        
        default:
            print("Invalid operator: \(oper.rawValue)")
            return 0
        }
    }
}
