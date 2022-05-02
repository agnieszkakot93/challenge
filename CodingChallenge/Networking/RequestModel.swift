//
//  RequestModel.swift
//  CodingChallenge
//
//  Created by Agnieszka Kot on 28/04/2022.
//

import Foundation

struct RequestModel {
    var path: String
    var queryItems: [URLQueryItem] = []
}

extension RequestModel {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "staging-app.shiftkey.com"
        components.path = "/api/v2" + path
        components.queryItems = queryItems

        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }

        return url
    }
}

extension RequestModel {
    static func availableShifts(type: String? = nil, address: String, start: String? = nil, end: String? = nil) -> Self {
        return RequestModel(path: "/available_shifts", queryItems: [
            URLQueryItem(name: "type", value: type),
            URLQueryItem(name: "address", value: address),
            URLQueryItem(name: "start", value: start),
            URLQueryItem(name: "end", value: end)
        ])
    }
}
