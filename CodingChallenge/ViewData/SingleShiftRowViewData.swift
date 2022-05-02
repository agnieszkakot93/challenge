//
//  SingleShiftRowViewData.swift
//  CodingChallenge
//
//  Created by Agnieszka Kot on 29/04/2022.
//

import Foundation

struct SingleShiftRowViewData: Identifiable {

    // MARK: Internal stored properties
    var id = UUID().uuidString
    let shiftID: Int
    let startTime: String
    let endTime: String
    let premiumRate: Bool
    let covid: Bool
    let shiftKind: ShiftKind
    let withinDistance: Int
    let facilityType: FacilityType
    let localizedSpecialty: LocalizedSpecialty
    let title: String

    // MARK: Internal methods
    init(from model: Shift) {
        self.shiftID = model.shiftID
        self.startTime = DateTimeFormatter.changeFormat(str: model.startTime)
        self.endTime = DateTimeFormatter.changeFormat(str: model.endTime)
        self.premiumRate = model.premiumRate
        self.covid = model.covid
        self.shiftKind = model.shiftKind
        self.withinDistance = model.withinDistance
        self.facilityType = model.facilityType
        self.localizedSpecialty = model.localizedSpecialty
        self.title = [model.facilityType.name.rawValue, shiftKind.rawValue].joined(separator: " - ")
    }
}
