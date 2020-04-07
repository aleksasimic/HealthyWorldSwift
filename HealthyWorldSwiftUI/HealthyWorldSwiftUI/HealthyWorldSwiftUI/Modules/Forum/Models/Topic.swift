import Foundation
import SwiftUI

public struct Topic: Decodable, Identifiable {
    public var id: String
    var name: String
    var author: String
    var dateString: String
    var description: String
    var comments: [Comment]
    
    public init (name: String, author: String, dateString: String, comments: [Comment], description: String) {
        self.name = name
        self.dateString = dateString
        self.author = author
        self.comments = comments
        self.description = description
        self.id = UUID().uuidString
    }
}
