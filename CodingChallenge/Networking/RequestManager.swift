//
//  RequestProtocol.swift
//  CodingChallenge
//
//  Created by Agnieszka Kot on 27/04/2022.
//

import Foundation
import Combine

protocol RequestProtocol {
    func request<T>(type: T.Type, url: URL, params: [URLQueryItem]) -> AnyPublisher<T, Error> where T : Decodable
    func getAvaliableShifts(params: [URLQueryItem]) -> AnyPublisher<Data, URLError>
}

final class RequestManager: RequestProtocol {


    func request<T>(type: T.Type, url: URL, params: [URLQueryItem]) -> AnyPublisher<T, Error> where T : Decodable {
        var urlRequest = URLRequest(url: url)
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

    func getAvaliableShifts(params: [URLQueryItem]) -> AnyPublisher<Data, URLError> {
        var urlRequest = URLRequest(url: URL(String: "https://staging-app.shiftkey.com/api/v2/available_shifts"))
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
//
//import Foundation
//import Combine
//
//protocol APIServiceProtocol {
//    var request: RequestProtocol { get }
//}
//
//class APIService: APIServiceProtocol {
//
//    static let shared = APIService()
//    func getAvaliableShifts() -> AnyPublisher<Model, Error> {
//        var components = URLComponents(string: "https://staging-app.shiftkey.com/api/v2/available_shifts")!
//        components.queryItems = [
//            URLQueryItem(name: "type", value: "week"),
//            URLQueryItem(name: "address", value: "Dallas, TX")
//        ]
//        return request(with: components)
//                   .eraseToAnyPublisher()
//
//    }
//}
