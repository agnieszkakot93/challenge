//
//  CodingChallengeService.swift
//  CodingChallenge
//
//  Created by Agnieszka Kot on 28/04/2022.
//

import Combine
import Foundation

protocol CodingChallengeServiceProtocol: AnyObject {
    var requestManager: RequestProtocol { get }

    func fetchAvaliableShifts(for searchLocation: String, type: String) -> AnyPublisher<Model, Error>
}

final class CodingChallengeService: CodingChallengeServiceProtocol {
    let requestManager: RequestProtocol

    init(requestManager: RequestProtocol = RequestManager()) {
        self.requestManager = requestManager
    }

    func fetchAvaliableShifts(for searchLocation: String, type: String) -> AnyPublisher<Model, Error> {
        let endpoint = RequestModel.availableShifts(type: type, address: searchLocation)
        return requestManager.request(type: Model.self, url: endpoint.url, params: endpoint.queryItems)
    }
}
