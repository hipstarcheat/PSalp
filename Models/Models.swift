import Foundation

struct Shift: Codable, Identifiable {
    var id = UUID()
    let date: Date
    var revenue: String // Выручка за день
}

struct MonthlyShiftData: Codable {
    var dailyRate: String // Дневная ставка
    var shifts: [Shift] = [] // Список смен
}
