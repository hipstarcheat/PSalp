import Foundation
import Combine

struct CatalogItem: Identifiable {
    let id = UUID()          // Уникальный идентификатор
    let title: String        // Название элемента (например, название бренда, модели или вкуса)
    var children: [CatalogItem]? = nil  // Список дочерних элементов (например, модели для бренда)
    var details: [String]? = nil // Дополнительная информация (данные из листа "Вкус" для модели)
}
