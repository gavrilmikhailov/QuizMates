//
//  UserDefaultsService.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 14.02.2026.
//

import Foundation

public actor UserDefaultsService: UserDefaultsServiceProtocol {

    // MARK: - Private properties

    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    // MARK: - Initializer

    public init(suiteName: String? = nil) {
        if let name = suiteName, let customDefaults = UserDefaults(suiteName: name) {
            self.userDefaults = customDefaults
        } else {
            self.userDefaults = .standard
        }
    }

    // MARK: - UserDefaultsServiceProtocol

    public func set<T: Encodable & Sendable>(_ object: T, for key: UserDefaultsKey) throws {
        if let intValue = object as? Int {
            userDefaults.set(intValue, forKey: key.rawValue)
            return
        }
        if let boolValue = object as? Bool {
            userDefaults.set(boolValue, forKey: key.rawValue)
            return
        }
        if let stringValue = object as? String {
            userDefaults.set(stringValue, forKey: key.rawValue)
            return
        }
        if let doubleValue = object as? Double {
            userDefaults.set(doubleValue, forKey: key.rawValue)
            return
        }
        let data = try encoder.encode(object)
        userDefaults.set(data, forKey: key.rawValue)
    }

    public func get<T: Decodable & Sendable>(_ type: T.Type, for key: UserDefaultsKey) throws -> T? {
        if type == Int.self {
            return userDefaults.integer(forKey: key.rawValue) as? T
        }
        if type == Bool.self {
            return userDefaults.bool(forKey: key.rawValue) as? T
        }
        if type == String.self {
            return userDefaults.string(forKey: key.rawValue) as? T
        }
        if type == Double.self {
            return userDefaults.double(forKey: key.rawValue) as? T
        }
        guard let data = userDefaults.data(forKey: key.rawValue) else {
            return nil
        }
        return try decoder.decode(type, from: data)
    }

    public func delete(_ key: UserDefaultsKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }

    public func has(_ key: UserDefaultsKey) -> Bool {
        return userDefaults.object(forKey: key.rawValue) != nil
    }
}
