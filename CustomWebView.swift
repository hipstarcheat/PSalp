import SwiftUI
import WebKit

struct CustomWebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        
        // Поддержка свайпов для навигации
        webView.allowsBackForwardNavigationGestures = true
        
        // Загружаем URL
        let request = URLRequest(url: url)
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Обновление интерфейса при необходимости
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        // Реализация методов делегата навигации (при необходимости)
    }
}
