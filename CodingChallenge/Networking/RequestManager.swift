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
}

final class RequestManager: RequestProtocol {


    func request<T>(type: T.Type, url: URL, params: [URLQueryItem]) -> AnyPublisher<T, Error> where T : Decodable {
        let urlRequest = URLRequest(url: url)
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
