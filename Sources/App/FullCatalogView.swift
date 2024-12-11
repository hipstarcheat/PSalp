import SwiftUI

struct FullCatalogView: View {
    @StateObject private var viewModel = FullCatalogViewModel()
    @State private var currentLevel: Int = 0  // Уровень (0 - бренды, 1 - модели, 2 - вкусы)
    @State private var selectedBrand: FullCatalogItem? = nil
    @State private var selectedModel: FullCatalogItem? = nil
    @State private var selectedTaste: FullCatalogItem? = nil  // Для хранения выбранного вкуса
    @Binding var selectedTab: Int  // Привязка к текущей вкладке
    
    var body: some View {
        NavigationView {
            ZStack { // Используем ZStack для переключения уровней
                // Уровень 0: Бренды
                if currentLevel == 0 {
                    levelView(
                        title: "Бренды",
                        items: viewModel.allBrands,
                        onItemTap: { item in
                            selectedBrand = item
                            withAnimation(.easeInOut) { // Переход на модели
                                currentLevel = 1
                                viewModel.filterModels(for: item)
                            }
                        }
                    )
                    .transition(.move(edge: .trailing)) // Переход с брендов на модели: справа налево
                }
                
                // Уровень 1: Модели
                if currentLevel == 1 {
                    levelView(
                        title: "Модели",
                        items: viewModel.filteredItems,
                        onItemTap: { item in
                            selectedModel = item
                            withAnimation(.easeInOut) { // Переход на вкусы
                                currentLevel = 2
                                viewModel.filterTastes(for: item)
                            }
                        }
                    )
                    .transition(.move(edge: .trailing)) // Переход с моделей на вкусы: справа налево
                }
                
                // Уровень 2: Вкусы
                if currentLevel == 2 {
                    levelView(
                        title: "Вкусы",
                        items: viewModel.filteredItems,
                        onItemTap: { item in
                            selectedTaste = item
                        }
                    )
                    .transition(.move(edge: .trailing)) // Возврат с уровня вкусов на модели: слева направо
                }
            }
            .navigationTitle(currentLevel == 0 ? "Бренды" : currentLevel == 1 ? "Модели" : "Вкусы")
            .gesture(
                DragGesture()
                    .onEnded { value in
                        // Обрабатываем свайп слева направо (возврат назад)
                        if value.translation.width > 100 {  // Ширина для активации свайпа
                            switch currentLevel {
                            case 1:  // Возврат к брендам
                                withAnimation(.easeInOut) {
                                    currentLevel = 0
                                    viewModel.filteredItems = viewModel.allBrands
                                }
                            case 2:  // Возврат к моделям
                                withAnimation(.easeInOut) {
                                    currentLevel = 1
                                    viewModel.filterModels(for: selectedBrand!)
                                }
                            default:
                                break
                            }
                        }
                        
                    }
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if currentLevel > 0 {
                        Button("Назад") {
                            resetCurrentLevel()
                        }
                    }
                }
            }
        }
    }
    
    // Универсальная функция для отображения уровней
    func levelView(
        title: String,
        items: [FullCatalogItem],
        onItemTap: @escaping (FullCatalogItem) -> Void
    ) -> some View {
        VStack {
            TextField("Поиск", text: $viewModel.searchQuery)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if viewModel.isLoading {
                ProgressView("Загрузка...")
            } else {
                List(items) { item in
                    Button(action: {
                        onItemTap(item)
                    }) {
                        HStack {
                            Text(item.title)
                            Spacer()
                            if let imageURL = item.imageURL, let url = URL(string: imageURL) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                }
            }
        }
        .background(
            NavigationLink(destination: TasteDetailView(taste: selectedTaste), isActive: Binding(
                get: { selectedTaste != nil },
                set: { if !$0 { selectedTaste = nil } }
            )) {
                EmptyView()
            }
        )
    }
    
    // Сброс текущего уровня и перезагрузка данных
    private func resetCurrentLevel() {
        withAnimation(.easeInOut) {
            switch currentLevel {
            case 2:  // Из вкусов в модели
                currentLevel = 1
                selectedTaste = nil
                if let selectedBrand = selectedBrand {
                    viewModel.filterModels(for: selectedBrand)
                }
            case 1:  // Из моделей в бренды
                currentLevel = 0
                selectedModel = nil
                viewModel.filteredItems = viewModel.allBrands
            default:
                break
            }
        }
    }
}

struct TasteDetailView: View {
    let taste: FullCatalogItem?
    
    var body: some View {
        VStack {
            if let taste = taste {
                Text(taste.title)
                    .font(.largeTitle)
                    .padding()
                
                // Вывод картинки с нужным размером
                if let imageURL = taste.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 300, height: 300) // Большой размер картинки
                    .padding()
                } else {
                    Text("Изображение отсутствует")
                        .foregroundColor(.gray)
                }
                
                // Описание вкуса
                if let description = taste.description {
                    Text("Артикул для ввода в МойСклад: \(description)")
                        .padding()
                        .foregroundColor(.blue)
                }
            } else {
                Text("Выберите вкус для подробностей.")
                    .padding()
            }
        }
        .navigationTitle("Описание Вкуса")
    }
}
