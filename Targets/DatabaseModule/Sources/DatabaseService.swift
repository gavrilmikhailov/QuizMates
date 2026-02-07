//
//  DatabaseService.swift
//  DatabaseService
//
//  Created by Gavriil Mikhailov on 07.02.2026.
//

import Foundation
import SwiftData

@ModelActor
public actor DatabaseService: DatabaseServiceProtocol {

    public func fetch<T: PersistentModel, V: Sendable>(
        modelType: T.Type,
        transformer: @escaping @Sendable (T) -> V
    ) async throws -> [V] {
        return try modelContext
            .fetch(FetchDescriptor<T>())
            .map(transformer)
    }

    public func fetch<T: PersistentModel, V: Sendable>(
        ids: [PersistentIdentifier],
        transformer: @escaping @Sendable (T) -> V
    ) throws -> [V] {
        return ids
            .compactMap { id in
                modelContext.model(for: id) as? T
            }
            .map(transformer)
    }

    public func fetch<T: PersistentModel, V: Sendable>(
        id: PersistentIdentifier,
        transformer: @escaping @Sendable (T) -> V
    ) throws -> V {
        guard let model = modelContext.model(for: id) as? T else {
            throw DatabaseError.notFound
        }
        return transformer(model)
    }

    @discardableResult
    public func create<T: PersistentModel, V: Sendable>(
        from dto: V,
        transformer: @escaping @Sendable (V) -> T
    ) throws -> PersistentIdentifier {
        let model = transformer(dto)
        modelContext.insert(model)
        try modelContext.save()
        return model.persistentModelID
    }

    public func update<T: PersistentModel, V: Sendable>(
        id: PersistentIdentifier,
        with dto: V,
        modifier: @escaping @Sendable (T, V) -> Void
    ) throws {
        guard let model = modelContext.model(for: id) as? T else {
            throw DatabaseError.notFound
        }
        modifier(model, dto)
        try modelContext.save()
    }

    public func delete<T: PersistentModel>(
        modelType: T.Type,
        id: PersistentIdentifier
    ) throws {
        guard let model = modelContext.model(for: id) as? T else {
            throw DatabaseError.notFound
        }
        modelContext.delete(model)
        try modelContext.save()
    }
    
    public func delete<T: PersistentModel>(
        where descriptor: FetchDescriptor<T>
    ) throws {
        try modelContext.delete(model: T.self, where: descriptor.predicate)
        try modelContext.save()
    }
}
