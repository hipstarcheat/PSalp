import SwiftUI
import UserNotifications

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var selectedTab: Int = 0  // Отслеживаем текущую вкладку
    
    var body: some View {
        TabView(selection: $selectedTab) {  // Привязываем к TabView
            ScheduleView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("График")
                }
                .tag(0)  // Тег вкладки
            
            FullCatalogView(selectedTab: $selectedTab)  // Передаём привязку
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Каталог")
                }
                .tag(1)
            
            WebViewPage()
                .tabItem {
                    Image(systemName: "book.closed.fill")
                    Text("ГетКурс")
                }
                .tag(2)
            
            GoogleSheetView()
                .tabItem {
                    Image(systemName: "newspaper.circle")
                    Text("Цены")
                }
                .tag(3)
            
            TimerView()
                .tabItem {
                    Image(systemName: "timer")
                    Text("Таймер")
                }
                .tag(4)
            
            InformationView()
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("Информация")
                }
                .tag(5)
            
            HTReviewsView()
                .tabItem {
                    Image(systemName: "globe")
                    Text("HT Reviews")
                }
                .tag(6)
        }
        .tabViewStyle(DefaultTabViewStyle())  // Используем стандартный стиль для табов
    }
}




struct BlackCatalogViewOld: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Каталог")
                    .font(.largeTitle)
                    .padding(.top)
                
                Text("В разработке")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Каталог")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct TimerView: View {
    @State private var timer: Timer?
    @State private var timeElapsed: Int = 0
    @State private var isRunning: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Таймер")
                .font(.largeTitle)
                .padding(.top)
            
            Text(timeString(from: timeElapsed))
                .font(.system(size: 48, weight: .bold, design: .monospaced))
                .padding()
            
            HStack(spacing: 20) {
                Button(action: startTimer) {
                    Text("Старт")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: stopTimer) {
                    Text("Стоп")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            timeElapsed += 1
        }
    }
    
    private func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    private func timeString(from seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct InformationView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Информация")
                    .font(.largeTitle)
                    .padding(.top)
                
                Text("Приложение для планирования смен, учета выручки и управления временем.")
                    .font(.headline)
                    .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Информация")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


