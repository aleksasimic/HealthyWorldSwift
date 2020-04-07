import Foundation
import SwiftUI
import Combine

protocol HttpClientProtocol {
    func sendRequest <T: Decodable> (method: HttpMethod, url: URL, body: [String: AnyObject]?) -> AnyPublisher<T, Error>
}

struct HttpClient: HttpClientProtocol {
    let decoder: JSONDecoder
    init() {
        self.decoder = JSONDecoder()
    }
    func sendRequest<T>(method: HttpMethod, url: URL, body: [String : AnyObject]? = nil) -> AnyPublisher<T, Error> where T : Decodable {
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if method == .Post || method == .Put || body != nil {
            request.addValue(ContentType.Json, forHTTPHeaderField: HttpHeader.ContentType)
        }
        
        if let params = body {
            var data: Data
            data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            request.addValue(String(data.count), forHTTPHeaderField: HttpHeader.ContentLength)
            request.httpBody = data
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                let value = try self.decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func sendNoReplyRequest (method: HttpMethod, url: URL, body: [String : AnyObject]? = nil) -> AnyPublisher<Void, Error> {
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        
        if method == .Post || method == .Put || body != nil {
            request.addValue(ContentType.Json, forHTTPHeaderField: HttpHeader.ContentType)
        }
        
        if let params = body {
            var data: Data
            data = try! JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions())
            request.addValue(String(data.count), forHTTPHeaderField: HttpHeader.ContentLength)
            request.httpBody = data
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap {
                return ResponseNoReply($0.data)
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
            .map {
                _ in
            }
            .eraseToAnyPublisher()
    }
    
}

struct Response<T> {
      let value: T
      let response: URLResponse
}

public struct ResponseNoReply {
    public let data: Data
    public init() {
        self.data = Data()
    }
    
    public init(_ data: Data) {
        self.data = data
    }
}

//protocol HttpClientProtocol2 {
//    func sendRequest (method: HttpMethod, url: URL, body: [String: AnyObject]?) -> AnyPublisher<Void, Error>
//}
//
//struct HttpClient2: HttpClientProtocol2 {
//    let decoder: JSONDecoder
//    init() {
//        self.decoder = JSONDecoder()
//    }
//    func sendRequest(method: HttpMethod, url: URL, body: [String : AnyObject]? = nil) -> AnyPublisher<Void, Error> {
//
//        var request = URLRequest(url: url)
//        request.httpMethod = method.rawValue
//        if method == .Post || method == .Put || body != nil {
//            request.addValue(ContentType.Json, forHTTPHeaderField: HttpHeader.ContentType)
//        }
//
//        return URLSession.shared
//        .dataTaskPublisher(for: request)
//        .tryMap {
//            return Response2($0.data)
//        }
//        .receive(on: RunLoop.main)
//        .eraseToAnyPublisher()
//        .map {
//            _ in
//        }
//        .eraseToAnyPublisher()
//    }
//}


