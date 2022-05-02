//
//  AvaliableShiftsViewData.swift
//  CodingChallenge
//
//  Created by Agnieszka Kot on 29/04/2022.
//

import Foundation
import UIKit

struct AvaliableShiftsViewData: Identifiable {

    // MARK: Internal computed properties
    var weekDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd"

        let date = dateFormatter.date(from: weekDateString) ?? Date()
        return date
    }

    // MARK: Internal stored properties
    let weekDateString: String
    let id = UUID()
    let shiftList: [SingleShiftRowViewData]
}

extension AvaliableShiftsViewData {

    // MARK: Internal methods
    init(with model: ShiftsModel) {
        self.weekDateString = model.date
        self.shiftList = model.shifts.map { shift -> SingleShiftRowViewData in
            return SingleShiftRowViewData(from: shift)
        }
    }
}
