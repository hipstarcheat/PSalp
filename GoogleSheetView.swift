import SwiftUI

struct GoogleSheetView: View {
    @StateObject private var viewModel = GoogleSheetViewModel()
    
    var body: some View {
        VStack {
            Text("Последние изменения цен:")
                .font(.largeTitle)
                .padding()
            
            // Кнопка для загрузки данных
            Button(action: {
                viewModel.fetchData() // Загружаем данные при нажатии на кнопку
            }) {
                Text("Обновить")
                    .font(.title2)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            // Список для отображения данных
            List(viewModel.sheetData) { data in
                Text(data.content)
                    .padding(.vertical, 5)
                    .lineLimit(nil) // Разрешаем перенос строк в длинных данных
                    .multilineTextAlignment(.leading) // Выравнивание по левому краю
            }
        }
        .onAppear {
            viewModel.fetchData() // Загружаем данные при запуске
        }
    }
}

struct GoogleSheetView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSheetView()
    }
}
