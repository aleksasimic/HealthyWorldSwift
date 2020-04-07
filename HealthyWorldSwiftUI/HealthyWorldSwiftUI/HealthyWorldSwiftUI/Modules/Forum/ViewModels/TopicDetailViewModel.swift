import Foundation
import SwiftUI
import Combine

class TopicDetailViewModel: ObservableObject {
    @Published var commentText = ""
    @Published var comments: [Comment]
    
    @Published var loading = false
    @Published var showToast = false
    @Published var toastText = ""
    
    var service: ForumNetworkServiceProtocol
    
    init(service: ForumNetworkServiceProtocol, comments: [Comment]) {
        self.service = service
        self.comments = comments
    }
    
    func addComment(_ topicId: String) {
        let user = UserDefaults.standard.string(forKey: "username")!
        let dateFormatter = DateFormatter.customDateFormatter
        let dateString = dateFormatter.string(from: Date())
        let newComment = Comment(text: commentText, author: user, dateString: dateString, likes: 0, dislikes: 0)
        loading = true
        var cancelable: AnyCancellable
        cancelable = self.service.addComment(comment: newComment, topicId: topicId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.toastText = "Something went wrong, please try again"
                    self.showToast = true
                case .finished:
                    self.toastText = "Comment sucessfully added"
                    self.showToast = true
                }
                
            }, receiveValue: { newComments in
                self.comments = newComments
            })
        cancelable.cancel()
        loading = false
    }
    
    func addLike(_ comment: Comment, _ topicId: String) {
        loading = true
        var cancelable: AnyCancellable
        cancelable = self.service.addLike(comment: comment, topicId: topicId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.toastText = "Something went wrong, please try again"
                    self.showToast = true
                case .finished:
                    break
                }
                
            }, receiveValue: { newComments in
                self.comments = newComments
            })
        cancelable.cancel()
        loading = false
    }
    
    func addDisLike(_ comment: Comment, _ topicId: String) {
        loading = true
        var cancelable: AnyCancellable
        cancelable = self.service.addDislike(comment: comment, topicId: topicId)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.toastText = "Something went wrong, please try again"
                    self.showToast = true
                case .finished:
                    break
                }
                
            }, receiveValue: { newComments in
                self.comments = newComments
            })
        cancelable.cancel()
        loading = false
    }
}
