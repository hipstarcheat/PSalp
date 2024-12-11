import SwiftUI
import Combine

struct ShiftDetailView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    @State var shift: Shift
    @State private var revenue: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.formattedDate(shift.date))
                .font(.largeTitle)
            
            TextField("Введите выручку за день", text: $revenue)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding()
            
            Button(action: {
                if let revenueDouble = Double(revenue) {
                    viewModel.updateRevenue(for: shift.date, revenue: String(revenueDouble))
                }
            }) {
                Text("Сохранить")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .navigationTitle("Детали смены")
        .padding()
        .onAppear {
            revenue = shift.revenue // Инициализация значением из shift
        }
    }
}
