import Foundation
import SwiftUI
import Combine


class ForumViewModel: ObservableObject {
    @Published var topicName = ""
    @Published var topicDescription = ""
    @Published var topics = [Topic]()
    
    @Published var loading = false
    @Published var toastText = ""
    @Published var showToast = false
    
    
    let service: ForumNetworkServiceProtocol
    
    init(service: ForumNetworkServiceProtocol) {
        self.service = service
    }
    
    func addTopic() {
        let user = UserDefaults.standard.string(forKey: "username")!
        let dateFormatter = DateFormatter.customDateFormatter
        let dateString = dateFormatter.string(from: Date())
        let topicObj = Topic(name: topicName, author: user, dateString: dateString, comments: [Comment](), description: topicDescription)
        loading = true
        var cancellable: AnyCancellable?
        cancellable = service.addTopic(topic: topicObj)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.toastText = "Topic added successfully"
                    self.showToast = true
                case .failure:
                    self.toastText = "Something went wrong, please try again"
                    self.showToast = true
                }
            }, receiveValue: { newTopics in self.topics = newTopics })
        cancellable?.cancel()
        loading = false
    }
    
    func getTopics() {
        loading = true
        var cancellable: AnyCancellable?
        cancellable = service.getTopics()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                     self.toastText = "Topic added successfully"
                     self.showToast = true
                case .finished:
                    break
                }
            }, receiveValue: { newTopics in
                self.topics = newTopics
            })
        loading = false
        cancellable?.cancel()
    }
}
