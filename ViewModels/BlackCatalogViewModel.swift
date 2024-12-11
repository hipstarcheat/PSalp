import Foundation
import Combine

class BlackCatalogViewModel: ObservableObject {
    @Published var items: [CatalogItem] = []  // Список всех брендов и моделей
    @Published var selectedItem: CatalogItem? = nil  // Выбранный элемент
    @Published var isLoading: Bool = false  // Индикатор загрузки
    
    private let apiKey = "AIzaSyD6EDemx5WtKqBbkNS-QAJwxCi1vimlNUU"
    private let spreadsheetId = "1fd_Kkkwr_XIgfpeZvGUlPnqEed8-_iH9sWlNeq_quNU"
    
    // Загрузка данных первого уровня (лист "Бренд")
    func fetchBrands() {
        isLoading = true
        let range = "Бренд!1:1" // Строка 1 на листе "Бренд"
        
        loadSheet(range: range) { [weak self] data in
            DispatchQueue.main.async {
                self?.items = data.first?.compactMap { title in
                    title.isEmpty ? nil : CatalogItem(title: title) // Создаем элементы для каждого бренда
                } ?? []
                self?.isLoading = false
            }
        }
    }
    
    // Загрузка моделей для каждого бренда по порядку (лист "Модель")
    func fetchModels(for brandIndex: Int) {
        isLoading = true
        let column = String(UnicodeScalar(65 + brandIndex)!)  // Преобразуем индекс в букву столбца (A, B, C, ...)
        let range = "Модель!\(column):\(column)"  // Для выбранного бренда выбираем столбец с моделями
        
        loadSheet(range: range) { [weak self] data in
            DispatchQueue.main.async {
                if var brand = self?.items[brandIndex] {
                    brand.children = data.compactMap { $0.first }.compactMap { model in
                        model.isEmpty ? nil : CatalogItem(title: model)  // Создаем дочерние элементы для бренда
                    }
                    self?.selectedItem = brand  // Устанавливаем выбранный бренд с его моделями
                }
                self?.isLoading = false
            }
        }
    }
    
    // Загрузка данных для каждого вкуса, связанного с моделью
    func fetchTaste(for modelIndex: Int, forBrand brandIndex: Int) {
        isLoading = true
        guard modelIndex < items[brandIndex].children?.count ?? 0 else { return }
        
        let modelTitle = items[brandIndex].children?[modelIndex].title ?? ""
        let range = "Вкус!\(modelTitle):\(modelTitle)"  // Подгружаем вкусы для модели
        
        loadSheet(range: range) { [weak self] data in
            DispatchQueue.main.async {
                if var model = self?.items[brandIndex].children?[modelIndex] {
                    model.details = data.flatMap { $0 }
                    self?.items[brandIndex].children?[modelIndex] = model // Обновляем модель с вкусами
                    self?.selectedItem = model  // Устанавливаем выбранную модель
                }
                self?.isLoading = false
            }
        }
    }
    // Загрузка данных для "Вкусов" для конкретной модели
    func fetchTasteData(for model: CatalogItem) {
        isLoading = true
        let columnIndex = model.title.prefix(1).uppercased()  // Преобразуем в букву столбца
        let range = "Вкус!\(columnIndex):\(columnIndex)" // Пример диапазона столбцов A-J
        
        loadSheet(range: range) { [weak self] data in
            DispatchQueue.main.async {
                // Обновляем текущую модель с данными
                if var selectedModel = self?.selectedItem {
                    // Преобразуем данные в массив строк
                    selectedModel.details = data.flatMap { $0 }
                    // Обновляем модель в списке
                    if let selectedIndex = self?.items.firstIndex(where: { $0.id == selectedModel.id }) {
                        self?.items[selectedIndex] = selectedModel
                        self?.selectedItem = selectedModel // Устанавливаем выбранную модель
                    }
                }
                self?.isLoading = false
            }
        }
    }
    

    
    // Функция для загрузки данных из Google Sheets
    private func loadSheet(range: String, completion: @escaping ([[String]]) -> Void) {
        guard let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetId)/values/\(range)?key=\(apiKey)") else {
            print("Неверный URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Ошибка загрузки данных: \(String(describing: error))")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(SheetRespons.self, from: data)
                completion(response.values)
            } catch {
                print("Ошибка декодирования данных: \(error)")
            }
        }.resume()
    }
}

// Модель для обработки ответа Google Sheets API
struct SheetRespons: Codable {
    let values: [[String]]
}
