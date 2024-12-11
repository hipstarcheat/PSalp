import Foundation
import Combine

class FullCatalogViewModel: ObservableObject {
    @Published var allBrands: [FullCatalogItem] = []  // Все бренды
    @Published var allModels: [FullCatalogItem] = []  // Все модели
    @Published var allTastes: [FullCatalogItem] = []  // Все вкусы
    
    @Published var filteredItems: [FullCatalogItem] = []  // Отфильтрованные элементы для отображения
    @Published var searchQuery: String = ""  // Текст поиска
    @Published var isLoading: Bool = false  // Индикатор загрузки
    
    private let apiKey = "AIzaSyD6EDemx5WtKqBbkNS-QAJwxCi1vimlNUU"
    private let spreadsheetId = "1fd_Kkkwr_XIgfpeZvGUlPnqEed8-_iH9sWlNeq_quNU"
    
    private var cancellables = Set<AnyCancellable>()
    
    // Инициализация
    init() {
        $searchQuery
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.filterItems(by: query)
            }
            .store(in: &cancellables)
        loadAllData()
    }
    
    // Загрузка всех данных из таблицы
    func loadAllData() {
        isLoading = true
        let dispatchGroup = DispatchGroup()
        
        var brands: [String] = []
        var models: [String] = []
        var tastes: [String] = []
        var tasteDescriptions: [String?] = []  // Массив для хранения данных из столбца B (описания)
        var tasteImages: [String?] = []  // Массив для хранения URL картинок
        
        // Загрузка брендов
        dispatchGroup.enter()
        loadSheet(range: "Бренд!A:A") { data in
            brands = data.compactMap { $0.first }
            dispatchGroup.leave()
        }
        
        // Загрузка моделей
        dispatchGroup.enter()
        loadSheet(range: "Модель!A:A") { data in
            models = data.compactMap { $0.first }
            dispatchGroup.leave()
        }
        
        // Загрузка вкусов и их описаний
        dispatchGroup.enter()
        loadSheet(range: "Вкус!A:C") { data in
            tastes = data.compactMap { $0.first }
            tasteDescriptions = data.compactMap { $0[safe: 1] }  // Получаем описание из столбца B
            tasteImages = data.compactMap { $0[safe: 2] }
            dispatchGroup.leave()
        }
        
        // По завершении загрузки
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.allBrands = brands.map { FullCatalogItem(title: $0, description: nil, imageURL: nil) }
            self?.allModels = models.map { FullCatalogItem(title: $0, description: nil, imageURL: nil) }
            
            // Применяем описание к каждому элементу "Вкусов"
            self?.allTastes = tastes.enumerated().map { (index, taste) in
                let description = tasteDescriptions[safe: index]  // Получаем описание из массива
                let imageURL = tasteImages[safe: index]
                return FullCatalogItem(title: taste, description: description ?? "Нет описания", imageURL: imageURL ?? nil)
            }
            
            self?.filteredItems = self?.allBrands ?? []
            self?.isLoading = false
        }
    }
    
    // Фильтрация элементов
    func filterItems(by query: String) {
        if query.isEmpty {
            filteredItems = allBrands
        } else {
            filteredItems = allBrands.filter { $0.title.localizedCaseInsensitiveContains(query) } +
            allModels.filter { $0.title.localizedCaseInsensitiveContains(query) } +
            allTastes.filter { $0.title.localizedCaseInsensitiveContains(query) }
        }
    }
    
    // Фильтрация для перехода на уровни
    func filterModels(for brand: FullCatalogItem) {
        filteredItems = allModels.filter { $0.title.localizedCaseInsensitiveContains(brand.title) }
    }
    
    func filterTastes(for model: FullCatalogItem) {
        filteredItems = allTastes.filter { $0.title.localizedCaseInsensitiveContains(model.title) }
    }
    
    // Сброс фильтров и возвращение к брендам
    func resetToBrands() {
        filteredItems = allBrands
    }
    
    // Загрузка данных из Google Sheets
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
                let response = try JSONDecoder().decode(SheetResponse.self, from: data)
                completion(response.values ?? [])
            } catch {
                print("Ошибка декодирования данных: \(error)")
            }
        }.resume()
    }
}

// Модель для обработки ответа Google Sheets API
struct SheetResponse: Codable {
    let values: [[String]]?
}

// Расширение для безопасного индекса в массиве
extension Array {
    subscript(safe index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }
}
