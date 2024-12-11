import Foundation
import Combine


// Модель для данных из таблицы
struct GoogleSheetData: Identifiable {
    var id = UUID()
    var content: String
}

// Ответ от Google Sheets API
struct GoogleSheetsResponse: Codable {
    let values: [[String]]
}

class GoogleSheetViewModel: ObservableObject {
    @Published var sheetData: [GoogleSheetData] = []
    
    // Метод для загрузки данных
    func fetchData() {
        // Замените на ваш API ключ и ID таблицы
        let spreadsheetId = "1fd_Kkkwr_XIgfpeZvGUlPnqEed8-_iH9sWlNeq_quNU"
        let range = "Цены!A:A"  // Мы получаем все данные из столбца A
        let apiKey = "AIzaSyD6EDemx5WtKqBbkNS-QAJwxCi1vimlNUU"
        
        let url = URL(string: "https://sheets.googleapis.com/v4/spreadsheets/\(spreadsheetId)/values/\(range)?key=\(apiKey)")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let jsonResponse = try JSONDecoder().decode(GoogleSheetsResponse.self, from: data)
                    DispatchQueue.main.async {
                        // Преобразуем данные в структуру, подходящую для отображения
                        self.sheetData = jsonResponse.values.compactMap { row in
                            if let firstCell = row.first {
                                return GoogleSheetData(content: firstCell)
                            }
                            return nil
                        }
                    }
                } catch {
                    print("Ошибка при декодировании данных: \(error)")
                }
            } else if let error = error {
                print("Ошибка при запросе данных: \(error)")
            }
        }
        
        task.resume()
    }
    
}
