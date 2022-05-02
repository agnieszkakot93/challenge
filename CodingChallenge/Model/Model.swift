//
//  Model.swift
//  CodingChallenge
//
//  Created by Agnieszka Kot on 27/04/2022.
//

import Foundation

// MARK: - Welcome
struct Model: Codable {
    let data: [ShiftsModel]
}

// MARK: - ShiftsModel
struct ShiftsModel: Codable {
    let date: String
    let shifts: [Shift]
}

// MARK: - Shift
struct Shift: Codable {
    let shiftID: Int
    let startTime: String
    let endTime: String
    let normalizedStartDateTime, normalizedEndDateTime: String
    let timezone: Timezone
    let premiumRate, covid: Bool
    let shiftKind: ShiftKind
    let withinDistance: Int
    let facilityType, skill: FacilityType
    let localizedSpecialty: LocalizedSpecialty

    enum CodingKeys: String, CodingKey {
        case shiftID = "shift_id"
        case startTime = "start_time"
        case endTime = "end_time"
        case normalizedStartDateTime = "normalized_start_date_time"
        case normalizedEndDateTime = "normalized_end_date_time"
        case timezone
        case premiumRate = "premium_rate"
        case covid
        case shiftKind = "shift_kind"
        case withinDistance = "within_distance"
        case facilityType = "facility_type"
        case skill
        case localizedSpecialty = "localized_specialty"
    }
}

// MARK: - FacilityType
struct FacilityType: Codable {
    let id: Int
    let name: FacilityTypeName
    let color: Color
    let abbreviation: FacilityTypeAbbreviation?
}

enum FacilityTypeAbbreviation: String, Codable {
    case cmaCmtQma = "CMA/CMT/QMA"
    case cna = "CNA"
    case lvnLpn = "LVN/LPN"
    case rn = "RN"
}

enum Color: String, Codable {
    case af52De = "#AF52DE"
    case f5657C = "#F5657C"
    case ff2D55 = "#FF2D55"
    case ff9500 = "#FF9500"
    case the000000 = "#000000"
    case the007Aff = "#007AFF"
    case the5856D6 = "#5856D6"
    case the5Ac8Fa = "#5AC8FA"
}

enum FacilityTypeName: String, Codable {
    case acuteCare = "Acute Care"
    case assistedLivingFacility = "Assisted Living Facility"
    case certifiedNursingAide = "Certified Nursing Aide"
    case hospital = "Hospital"
    case licensedVocationalPracticalNurse = "Licensed Vocational/Practical Nurse"
    case longTermAcuteCare = "Long Term Acute Care"
    case longTermCare = "Long Term Care"
    case medSurg = "Med/Surg"
    case medicationAideTech = "Medication Aide/Tech"
    case personalCareHome = "Personal Care Home"
    case registeredNurse = "Registered Nurse"
    case skilledNursingFacility = "Skilled Nursing Facility"
}

// MARK: - LocalizedSpecialty
struct LocalizedSpecialty: Codable {
    let id, specialtyID, stateID: Int
    let name: LocalizedSpecialtyName
    let abbreviation: LocalizedSpecialtyAbbreviation
    let specialty: FacilityType

    enum CodingKeys: String, CodingKey {
        case id
        case specialtyID = "specialty_id"
        case stateID = "state_id"
        case name, abbreviation, specialty
    }
}

enum LocalizedSpecialtyAbbreviation: String, Codable {
    case cma = "CMA"
    case cna = "CNA"
    case lvn = "LVN"
    case rn = "RN"
}

enum LocalizedSpecialtyName: String, Codable {
    case certifiedMedicationAide = "Certified Medication Aide"
    case certifiedNursingAide = "Certified Nursing Aide"
    case licensedVocationalNurse = "Licensed Vocational Nurse"
    case registeredNurse = "Registered Nurse"
}

enum ShiftKind: String, Codable {
    case dayShift = "Day Shift"
    case eveningShift = "Evening Shift"
    case nightShift = "Night Shift"
}

enum Timezone: String, Codable {
    case central = "Central"
}

// MARK: - Meta
struct Meta: Codable {
    let lat, lng: Double
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
