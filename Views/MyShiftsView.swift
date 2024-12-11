import SwiftUI
import Combine

struct MyShiftsView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    @State private var isButtonPressed: Bool = false  // Переменная для отслеживания состояния кнопки
    @State private var isButtonExpanded: Bool = false  // Переменная для отслеживания раскрытия кнопки
    @State private var showMessage: Bool = false  // Переменная для показа сообщения о сбросе выручки
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // Список смен с переходом на страницу деталей смены
                    List(viewModel.selectedDates.sorted(), id: \.self) { date in
                        VStack {
                            // Навигация на страницу деталей смены
                            NavigationLink(destination: ShiftDetailView(viewModel: viewModel, shift: viewModel.getShift(for: date))) {
                                Text(viewModel.formattedDate(date))
                                    .padding()
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                
                // Добавление кнопки для сброса выручки
                VStack {
                    Spacer()  // Сдвигаем кнопку в правый нижний угол
                    HStack {
                        Spacer()
                        Button(action: {
                            if isButtonExpanded {
                                // Если кнопка раскрыта, сбрасываем выручки
                                viewModel.resetAllRevenues()
                                // Показываем сообщение о сбросе с анимацией
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showMessage = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    // Прячем сообщение через 2 секунды
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        showMessage = false
                                    }
                                }
                            }
                            // В любом случае раскрываем кнопку
                            withAnimation(.easeInOut(duration: 0.6)) {
                                isButtonExpanded.toggle()
                            }
                        }) {
                            ZStack {
                                if isButtonExpanded {
                                    // После нажатия показываем кнопку с текстом
                                    Text("Сбросить выручку")
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [Color(red: 0.8, green: 0.3, blue: 0.1), Color(red: 0.9, green: 0.7, blue: 0)]),
                                                           startPoint: .topLeading,
                                                           endPoint: .bottomTrailing)
                                        )
                                        .foregroundColor(.red)
                                        .fontWeight(.bold)  // Сделаем текст жирным
                                        .cornerRadius(30)
                                        .padding(.horizontal)
                                        .transition(.opacity)  // Анимация плавного появления
                                        .overlay(
                                            Text("Сбросить выручку")
                                                .fontWeight(.bold)
                                                .font(.system(size: 18))
                                                .foregroundColor(.clear)  // Делаем основной текст прозрачным
                                                .overlay(
                                                    Text("Сбросить выручку")  // Этот слой будет виден
                                                        .foregroundColor(.red)  // Цвет обводки
                                                        .fontWeight(.bold)
                                                        .font(.system(size: 18))
                                                        .shadow(color: .black, radius: 1.5)  // Используем тень как обводку
                                                )
                                            )
                                } else {
                                    // Иконка мусорной корзины до нажатия
                                    Image(systemName: "trash.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.white)
                                        .padding(12)
                                        .background(
                                            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]),
                                                           startPoint: .topLeading,
                                                           endPoint: .bottomTrailing)
                                        )
                                        .clipShape(Circle())
                                        .shadow(radius: 10)
                                        .transition(.scale)  // Анимация плавного сжатия
                                        .offset(x: isButtonExpanded ? 100 : 0)  // Анимация сдвига
                                }
                            }
                        }
                        .padding(.trailing, 7)  // Размещение кнопки в правом нижнем углу
                        .padding(.bottom, 20)  // Сдвиг кнопки вверх
                    }
                }
                
                // Всплывающее сообщение о сбросе
                if showMessage {
                    VStack {
                        Text("Выручка сброшена")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                            .transition(.opacity)  // Плавное исчезновение
                            .animation(.easeInOut(duration: 0.3), value: showMessage)  // Плавное появление
                    }
                    .padding(.bottom, 80)
                    .padding(.horizontal, 30)
                }
            }
            .navigationTitle("Мои смены")  // Заголовок страницы
        }
    }
}
