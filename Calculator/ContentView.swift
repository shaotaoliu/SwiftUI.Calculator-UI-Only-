import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black
                .ignoresSafeArea()
            
            VStack(alignment: .trailing) {
                Text(vm.display)
                    .font(.system(size: vm.resultFontSize))
                    .foregroundColor(vm.resultForegroundColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                
                VStack(spacing: vm.buttonSpacing) {
                    ForEach(vm.buttons, id:\.self) { row in
                        HStack(spacing: vm.buttonSpacing) {
                            ForEach(row, id:\.self) { button in
                                Button(action: {
                                    vm.tapButton(button: button)
                                }, label: {
                                    Text(button.rawValue)
                                        .font(.system(size: vm.buttonFontSize))
                                        .foregroundColor(button.foregroundColor)
                                        .frame(width: getButtonWidth(button: button), height: getButtonHeight())
                                        .background(button.backgroundColor)
                                        .cornerRadius(getButtonHeight() / 2)
                                })
                            }
                        }
                    }
                }
            }
            .padding(vm.buttonSpacing)
        }
    }
    
    func getButtonWidth(button: CalculatorButton) -> CGFloat {
        if button == .zero {
            return (UIScreen.main.bounds.width - vm.buttonSpacing * CGFloat(3)) / CGFloat(2)
        }
        return getButtonHeight()
    }
    
    func getButtonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - vm.buttonSpacing * CGFloat(5)) / CGFloat(4)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
