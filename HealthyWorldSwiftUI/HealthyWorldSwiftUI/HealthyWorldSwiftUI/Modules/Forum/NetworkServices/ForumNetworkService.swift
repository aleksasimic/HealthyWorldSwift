import Foundation
import Combine

struct ForumNetworkService: ForumNetworkServiceProtocol {
    let httpClient: HttpClient
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
    func getTopics() -> AnyPublisher<[Topic], Error> {
        let url = URL(string: Endpoints.Forum)!
        return httpClient.sendRequest(method: .Get, url: url)
    }
    
    func addTopic(topic: Topic) -> AnyPublisher<[Topic], Error> {
        let url = URL(string: Endpoints.AddTopic)!
        
        let body: Json = [
            Keys.Id : topic.id as AnyObject,
            Keys.Name : topic.name as AnyObject,
            Keys.Author : topic.author as AnyObject,
            Keys.DateString : topic.dateString as AnyObject,
            Keys.Comments : topic.comments as AnyObject,
            Keys.Description: topic.description as AnyObject
        ]
        return httpClient.sendRequest(method: .Post, url: url, body: body)
    }
    
    func addComment(comment: Comment, topicId: String) -> AnyPublisher<[Comment], Error> {
        let urlString = "\(Endpoints.AddComment)/\(topicId)"
        let url = URL(string: urlString)!
        
        let body: Json = [
            Keys.Id: comment.id as AnyObject,
            Keys.Text: comment.text as AnyObject,
            Keys.Author: comment.author as AnyObject,
            Keys.DateString: comment.dateString as AnyObject,
            Keys.Likes: comment.likes as AnyObject,
            Keys.Dislikes: comment.dislikes as AnyObject
        ]
        
        return httpClient.sendRequest(method: .Post, url: url, body: body)
    }
    
    func addLike(comment: Comment, topicId: String) -> AnyPublisher<[Comment], Error> {
        let urlString = "\(Endpoints.LikeComment)/\(topicId)"
        let url = URL(string: urlString)!
        
        let body: Json = [
            Keys.Id: comment.id as AnyObject,
            Keys.Text: comment.text as AnyObject,
            Keys.Author: comment.author as AnyObject,
            Keys.DateString: comment.dateString as AnyObject,
            Keys.Likes: comment.likes as AnyObject,
            Keys.Dislikes: comment.dislikes as AnyObject
        ]
        
        return httpClient.sendRequest(method: .Patch, url: url, body: body)
        
    }
    
    func addDislike(comment: Comment, topicId: String) -> AnyPublisher<[Comment], Error> {
        let urlString = "\(Endpoints.DislikeComment)/\(topicId)"
        let url = URL(string: urlString)!
        
        let body: Json = [
            Keys.Id: comment.id as AnyObject,
            Keys.Text: comment.text as AnyObject,
            Keys.Author: comment.author as AnyObject,
            Keys.DateString: comment.dateString as AnyObject,
            Keys.Likes: comment.likes as AnyObject,
            Keys.Dislikes: comment.dislikes as AnyObject
        ]
        
        return httpClient.sendRequest(method: .Patch, url: url, body: body)
    }
}

private extension ForumNetworkService {
    struct Endpoints {
        static let Forum = "http://localhost:8080/forum"
        static let AddTopic = "\(Forum)/addTopic"
        static let AddComment = "\(Forum)/addComment"
        static let LikeComment = "\(Forum)/like"
        static let DislikeComment = "\(Forum)/dislike"
    }
    struct Keys {
        static let Id = "id"
        static let Name = "name"
        static let Author = "author"
        static let DateString = "dateString"
        static let Comments = "comments"
        static let Description = "description"
        
        static let Text = "text"
        static let Likes = "likes"
        static let Dislikes = "dislikes"
    }
}
