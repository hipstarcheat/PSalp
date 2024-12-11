import Foundation

struct FullCatalogItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String? // Описание вкуса (если есть)
    let imageURL: String?  // Ссылка на картинк
    
    // Реализация hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // Уникальный идентификатор
        hasher.combine(title) // Название
    }
    
    // Реализация Equatable, чтобы можно было сравнивать объекты
    static func == (lhs: FullCatalogItem, rhs: FullCatalogItem) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title
    }
}
