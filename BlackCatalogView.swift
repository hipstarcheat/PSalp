import SwiftUI

struct BlackCatalogView: View {
    @StateObject private var viewModel = BlackCatalogViewModel()
    
    var body: some View {
        NavigationView {
            VStack {  // Используем VStack для корректного отображения состояния
                if viewModel.isLoading {
                    ProgressView("Загрузка...") // Показать прогресс во время загрузки
                } else if let selectedItem = viewModel.selectedItem {
                    // Второй уровень: модели, связанные с брендом
                    List(selectedItem.children ?? []) { model in
                        Button(action: {
                            // Получаем данные для выбранной модели
                            viewModel.fetchTasteData(for: model)
                        }) {
                            Text(model.title)
                        }
                        .background(
                            Text(self.formatDetails(for: model))  // Отображаем вкусы для модели
                        )
                    }
                    .navigationTitle(selectedItem.title)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Назад") {
                                viewModel.selectedItem = nil
                            }
                        }
                    }
                } else {
                    // Первый уровень: бренды
                    List(viewModel.items.indices, id: \.self) { index in
                        Button(action: {
                            viewModel.fetchModels(for: index)
                        }) {
                            Text(viewModel.items[index].title)
                        }
                    }
                    .navigationTitle("Бренды")
                }
            }
        }
        .onAppear {
            viewModel.fetchBrands()
        }
    }
    
    // Функция для форматирования деталей
    private func formatDetails(for model: CatalogItem) -> String {
        guard let details = model.details else {
            return "" // Если деталей нет, возвращаем пустую строку
        }
        
        return details.joined(separator: ", ") // Соединяем строки через запятую
    }
}
