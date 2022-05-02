//
//  ModalViewData.swift
//  CodingChallenge
//
//  Created by Agnieszka Kot on 02/05/2022.
//

import Foundation

struct ModalViewData {

    // MARK: Internal Stored Properties
    let title: String
    let distance: String
    let time: String
    let payType: String
    let shiftType: String
    let careType: String

    init(from model: SingleShiftRowViewData) {
        self.title = model.title
        self.distance = "Within \(model.withinDistance) ml"
        self.time = model.startTime + "-" + model.endTime
        self.payType = model.premiumRate ? "Premium Pay" : "Standard"
        self.shiftType = model.shiftKind.rawValue
        self.careType = model.localizedSpecialty.name.rawValue
    }
}
