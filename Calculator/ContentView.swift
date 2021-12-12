import SwiftUI

struct ContentView: View {
    
    private let buttons: [[CalculatorButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .mutliply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]
    
    private let buttonSpacing: CGFloat = 15
    private let buttonFontSize: CGFloat = 32
    private let resultFontSize: CGFloat = 80
    private let resultForegroundColor = Color.white
    
    @State var result = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black
                .ignoresSafeArea()
            
            VStack(alignment: .trailing) {
                Text("\(result)")
                    .font(.system(size: resultFontSize))
                    .foregroundColor(resultForegroundColor)
                
                VStack(spacing: buttonSpacing) {
                    ForEach(buttons, id:\.self) { row in
                        HStack(spacing: buttonSpacing) {
                            ForEach(row, id:\.self) { button in
                                Button(action: {
                                    
                                }, label: {
                                    Text(button.rawValue)
                                        .font(.system(size: buttonFontSize))
                                        .foregroundColor(button.foregroundColor)
                                        .frame(width: getButtonWidth(button: button), height: getButtonHeight())
                                })
                                    .background(button.backgroundColor)
                                    .cornerRadius(getButtonHeight() / 2)
                            }
                        }
                    }
                }
            }
            .padding(buttonSpacing)
        }
    }
    
    func getButtonWidth(button: CalculatorButton) -> CGFloat {
        if button == .zero {
            return (UIScreen.main.bounds.width - buttonSpacing * CGFloat(3)) / CGFloat(2)
        }
        
        return (UIScreen.main.bounds.width - buttonSpacing * CGFloat(5)) / CGFloat(4)
    }
    
    func getButtonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - buttonSpacing * CGFloat(5)) / CGFloat(4)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
