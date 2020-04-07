import Foundation
import SwiftUI

public struct Comment: Decodable, Identifiable {
    public var id: String
    var text: String
    var author: String
    var dateString: String
    var likes: Int
    var dislikes: Int
    
    public init(text: String, author: String, dateString: String, likes: Int, dislikes: Int) {
        self.text = text
        self.author = author
        self.dateString = dateString
        self.likes = likes
        self.dislikes = dislikes
        self.id = UUID().uuidString
    }
}
