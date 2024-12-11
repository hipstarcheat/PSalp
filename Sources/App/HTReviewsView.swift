import SwiftUI

struct HTReviewsView: View {
    private let urlString = "https://htreviews.org"
    
    var body: some View {
        if let url = URL(string: urlString) {
            CustomWebView(url: url)
                .edgesIgnoringSafeArea(.all) // Сайт занимает весь экран
        } else {
            Text("Неверный URL")
                .foregroundColor(.red)
                .font(.headline)
        }
    }
}
