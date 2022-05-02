//
//  RequestModel.swift
//  CodingChallenge
//
//  Created by Agnieszka Kot on 28/04/2022.
//

import Foundation

struct RequestModel {
    var path: String
    var queryParams: [URLQueryItem] = []
}
