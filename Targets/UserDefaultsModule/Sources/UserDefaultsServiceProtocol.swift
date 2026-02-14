//
//  UserDefaultsServiceProtocol.swift
//  QuizMates
//
//  Created by Gavriil Mikhailov on 14.02.2026.
//

import Foundation

public protocol UserDefaultsServiceProtocol: Sendable {
    func set<T: Encodable & Sendable>(_ object: T, for key: UserDefaultsKey) async throws
    func get<T: Decodable & Sendable>(_ type: T.Type, for key: UserDefaultsKey) async throws -> T?
    func delete(_ key: UserDefaultsKey) async
    func has(_ key: UserDefaultsKey) async -> Bool
}
