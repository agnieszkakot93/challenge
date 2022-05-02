//
//  DateTimeFormatter.swift
//  CodingChallenge
//
//  Created by Agnieszka Kot on 29/04/2022.
//

import Foundation
import UIKit

class DateTimeFormatter {
    private static let dateOnlyFormatter: DateFormatter = {
        let apiDateFormatter = DateFormatter()
        apiDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        apiDateFormatter.dateFormat = "yyyy-MM-dd"
        return apiDateFormatter
    }()
    
    static func apiDateString(from value: Date) -> String? {
        return DateTimeFormatter.dateOnlyFormatter.string(from: value)
    }

    static func changeFormat(str: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = formatter.date(from: str) else { return ""}

        formatter.dateFormat = "HH:mm"
        let string = formatter.string(from: date)
        return string
    }

    static func formatDate(_ format: String, fromDate date: Date) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = format
        return dateFormatterGet.string(from: date)
    }

    static func stringToDate(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        let date = dateFormatter.date(from: string) ?? Date()
        return date
    }
}
