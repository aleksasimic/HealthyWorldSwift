
import SwiftUI

class ImageLoader: ObservableObject {
    @Published var dataIsValid = false
    var data:Data?

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.dataIsValid = true
                self.data = data
            }
        }
        task.resume()
    }
}

struct ImageViewContainer: View {
    @ObservedObject var imageLoader: ImageLoader
    
    init(imageURL: String) {
         imageLoader = ImageLoader(urlString: imageURL)
    }
    
    func imageFromData(_ data:Data) -> UIImage {
           UIImage(data: data) ?? UIImage()
       }
    
    var body: some View {
          VStack {
            Image(uiImage: imageLoader.dataIsValid ? imageFromData(imageLoader.data!) : UIImage(named: "healthy_world_logo")!)
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width:100, height:100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.primaryColor, lineWidth: 0.5))
                    .shadow(radius: 4)
        }
    }
}


