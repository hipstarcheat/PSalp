import SwiftUI
import Combine


struct SettingsView: View {
    
    @State private var showSettings: Bool = false
    @Binding var dailyRate: String
    @ObservedObject var viewModel: ScheduleViewModel
    @FocusState private var isInputFocused: Bool // Управление фокусом
    @State private var localDailyRate: String
    
    init(dailyRate: Binding<String>, viewModel: ScheduleViewModel) {
        _dailyRate = dailyRate
        self.viewModel = viewModel
        // Инициализация локального значения с текущим окладом из viewModel
        _localDailyRate = State(initialValue: viewModel.dailyRate)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Параметры")
                .font(.largeTitle)
            
            TextField("Дневная ставка", text: $localDailyRate) // Привязка через локальное состояние
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .focused($isInputFocused) // Привязка фокуса
                .onSubmit {
                    saveDailyRate()
                }
                .padding()
            
            Button(action: {
                saveDailyRate()
                isInputFocused = false // Снятие фокуса после сохранения
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // Скрываем клавиатур
            }) {
                Text("Сохранить")
                    .font(.body)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            isInputFocused = true // Автоматический фокус при открытии
        }
    }
    
    private func saveDailyRate() {
        viewModel.saveDailyRate(localDailyRate)
        print("Дневная ставка сохранена: \(localDailyRate)")
    }
}
