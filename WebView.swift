import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let initialURLString: String
    @AppStorage("lastVisitedURL") private var lastVisitedURL: String = ""
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Загружаем последний URL или начальный, если ранее не сохранено
        let urlToLoad = URL(string: lastVisitedURL.isEmpty ? initialURLString : lastVisitedURL)
        if let url = urlToLoad {
            webView.load(URLRequest(url: url))
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Сохраняем текущий URL в AppStorage
            if let currentURL = webView.url?.absoluteString {
                parent.lastVisitedURL = currentURL
            }
        }
    }
}
