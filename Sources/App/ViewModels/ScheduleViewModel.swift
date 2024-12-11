import Foundation
import Combine

class ScheduleViewModel: ObservableObject {
    @Published var shifts: [Shift] = [] // Список смен
    @Published var dailyRate: String = "0" // Дневная ставка
    @Published var selectedDates: Set<Date> = [] // Выбранные даты
    
    private let calendar = Calendar.current
    private let storageKey = "ScheduleData"
    private let dailyRateKey = "dailyRate" // Ключ для дневной ставки
    
    init() {
        loadData()
    }
    
    // Сохранение данных
    func saveData() {
        let shiftData = MonthlyShiftData(dailyRate: dailyRate, shifts: shifts)
        if let encoded = try? JSONEncoder().encode(shiftData) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    // Загрузка данных
    func loadData() {
        guard let savedData = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode(MonthlyShiftData.self, from: savedData) else { return }
        dailyRate = decoded.dailyRate
        shifts = decoded.shifts
    }
    
    // Обновление выручки
    func updateRevenue(for date: Date, revenue: String) {
        if let index = shifts.firstIndex(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            if selectedDates.contains(date) {
                shifts[index].revenue = revenue // Обновляем выручку
            } else {
                shifts[index].revenue = "0" // Сбрасываем выручку, если дата удалена
            }
        } else if selectedDates.contains(date) {
            let newShift = Shift(date: date, revenue: revenue)
            shifts.append(newShift)
        }
        saveData()
    }
    
    // Подсчёт месячной зарплаты
    // В ScheduleViewModel
    
    func calculateMonthlySalary() -> Double {
        // Преобразуем оклад в число
        let dailyRateDouble = Double(dailyRate) ?? 0
        
        // Количество выбранных смен
        let selectedShiftsCount = selectedDates.count
        
        // Сумма выручки по всем выбранным сменам (выручка умноженная на 0.03 для каждой смены)
        let totalRevenue = shifts.filter { selectedDates.contains($0.date) }
            .reduce(0.0) { (result, shift) in
                guard let revenue = Double(shift.revenue) else { return result }
                return result + (revenue * 0.03)
            }
        
        // Месячная зарплата = (Оклад * Количество выбранных смен) + Сумма выручки
        return (dailyRateDouble * Double(selectedShiftsCount)) + totalRevenue
    }
    
    // Форматирование дат
    func formattedDate(_ date: Date, format: String = "d MMMM, EEEE") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func saveDailyRate(_ rate: String) {
        self.dailyRate = rate
        // Здесь может быть логика для сохранения данных в хранилище, например UserDefaults
        UserDefaults.standard.set(rate, forKey: "dailyRateKey")
    }
    
    func getSelectedShifts() -> [Shift] {
        shifts.filter { selectedDates.contains($0.date) }
    }
    
    func getRevenue(for date: Date) -> String {
        if let shift = shifts.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            return shift.revenue
        }
        return "0"
    }
    
    func getShift(for date: Date) -> Shift {
        if let shift = shifts.first(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            return shift
        }
        // Если смены для этой даты нет, создаем новую с пустыми значениями
        return Shift(date: date, revenue: "0")
    }
    
    func resetAllRevenues() {
        // Сбрасываем выручку на всех сменах
        for index in shifts.indices {
            shifts[index].revenue = "0"  // Сбрасываем выручку на 0
        }
        saveData()  // Сохраняем изменения
    }

}
