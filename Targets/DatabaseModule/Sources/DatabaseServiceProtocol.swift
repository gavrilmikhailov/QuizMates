//
//  DatabaseServiceProtocol.swift
//  DatabaseService
//
//  Created by Gavriil Mikhailov on 07.02.2026.
//

import Foundation
import SwiftData

public protocol DatabaseServiceProtocol: Sendable {

    func fetch<T: PersistentModel, V: Sendable>(
        modelType: T.Type,
        transformer: @escaping @Sendable (T) -> V
    ) async throws -> [V] 

    func fetch<T: PersistentModel, V: Sendable>(
        ids: [PersistentIdentifier],
        transformer: @escaping @Sendable (T) -> V
    ) async throws -> [V]

    func fetch<T: PersistentModel, V: Sendable>(
        id: PersistentIdentifier,
        transformer: @escaping @Sendable (T) -> V
    ) async throws -> V

    @discardableResult
    func create<T: PersistentModel, V: Sendable>(
        from dto: V,
        transformer: @escaping @Sendable (V) -> T
    ) async throws -> PersistentIdentifier

    func update<T: PersistentModel, V: Sendable>(
        id: PersistentIdentifier,
        with dto: V,
        modifier: @escaping @Sendable (T, V) -> Void
    ) async throws

    func delete<T: PersistentModel>(
        modelType: T.Type,
        id: PersistentIdentifier
    ) async throws

    func delete<T: PersistentModel>(
        where descriptor: FetchDescriptor<T>
    ) async throws
}
