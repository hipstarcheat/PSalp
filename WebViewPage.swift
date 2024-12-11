import SwiftUI

struct WebViewPage: View {
    private let initialURL = "https://training.psjob.ru/teach/control"
    
    var body: some View {
        ZStack {
            // Веб-просмотрщик
            WebView(initialURLString: initialURL)
            
            // Плавающая кнопка "Домой"
            VStack {
                HStack {
                    Spacer()
                    Button(action: resetToHomePage) {
                        Image(systemName: "house.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(10)
                            .background(
                                Circle()
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color.yellow, Color.orange]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ))
                            )
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .padding(.trailing, 16)
                }
                .padding(.top, 10) // Отступ сверху
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all) // Расширение области на весь экран
    }
    
    // Сброс на изначальную страницу
    private func resetToHomePage() {
        UserDefaults.standard.removeObject(forKey: "lastVisitedURL")
    }
}
