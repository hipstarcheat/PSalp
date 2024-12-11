import SwiftUI
import Combine

struct ScheduleView: View {
    @StateObject private var viewModel = ScheduleViewModel()
    @State private var showSettings: Bool = false
    @State private var dailyRate = "" // Храним дневную ставку
    @FocusState private var isInputFocused: Bool
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
    
    private var currentMonthDates: [Date] {
        let now = Date()
        guard let range = calendar.range(of: .day, in: .month, for: now),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) else {
            return []
        }
        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
    
    private var currentMonthName: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: Date()).capitalized
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Text("График")
                        .font(.largeTitle)
                    Spacer()
                    Button(action: { showSettings.toggle() }) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.orange)
                    }
                }
                .padding(.horizontal)
                
                Text("Месячная зарплата: \(String(format: "%.2f", viewModel.calculateMonthlySalary())) ₽")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.orange)
                    )
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 10) {
                        HStack {
                            ForEach(daysOfWeek, id: \.self) { day in
                                Text(day)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                            ForEach(currentMonthDates, id: \.self) { date in
                                VStack {
                                    Button(action: {
                                        if viewModel.selectedDates.contains(date) {
                                            viewModel.selectedDates.remove(date)
                                        } else {
                                            viewModel.selectedDates.insert(date)
                                        }
                                    }) {
                                        Text("\(calendar.component(.day, from: date))")
                                            .frame(width: 40, height: 40)
                                            .background(viewModel.selectedDates.contains(date) ? Color.orange : Color.clear)
                                            .clipShape(Circle())
                                            .foregroundColor(viewModel.selectedDates.contains(date) ? .white : .primary)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                NavigationLink(destination: MyShiftsView(viewModel: viewModel)) {
                    Text("Посмотреть мои смены")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView(dailyRate: $dailyRate, viewModel: viewModel) // Передаем viewModel
            }
            .navigationTitle(currentMonthName)
        }
    }
}
