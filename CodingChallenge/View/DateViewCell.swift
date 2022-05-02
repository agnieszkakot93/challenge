//
//  DateViewCell.swift
//  CodingChallenge
//
//  Created by Agnieszka Kot on 02/05/2022.
//
import SwiftUI

struct DateViewCell: View {
    var date: Date

    var body: some View {
        VStack(alignment: .center) {
            Text(dayName).font(.system(.body)).foregroundColor(.blue)
            Text(dayNumber).font(.system(.footnote))
        }
        .padding(.horizontal, 8)
        .cornerRadius(10)
    }

    var dayName: String { return DateTimeFormatter.formatDate("EE", fromDate: date) }
    var dayNumber: String { return DateTimeFormatter.formatDate("d", fromDate: date) }
}
