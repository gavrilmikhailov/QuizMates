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
        descriptor: FetchDescriptor<T>,
        transformer: @escaping @Sendable (T) -> V
    ) throws -> [V] {
        let models = try modelContext.fetch(descriptor)
        return models.map(transformer)
    }
    
    public func fetchOne<T: PersistentModel, V: Sendable>(
        id: PersistentIdentifier,
        transformer: @escaping @Sendable (T) -> V
    ) throws -> V? {
        guard let model = modelContext.model(for: id) as? T else {
            return nil
        }
        return transformer(model)
    }

    public func create<T: PersistentModel, V: Sendable>(
        from dto: V,
        transformer: @escaping @Sendable (V) -> T
    ) throws {
        // 1. Превращаем DTO в Модель внутри актора
        let model = transformer(dto)
        
        // 2. Вставляем в контекст
        modelContext.insert(model)
        
        // 3. Сохраняем
        try modelContext.save()
    }
    
    public func update<T: PersistentModel, V: Sendable>(
        id: PersistentIdentifier,
        with dto: V,
        modifier: @escaping @Sendable (T, V) -> Void
    ) throws {
        // 1. Ищем модель по ID
        guard let model = modelContext.model(for: id) as? T else {
            // Можно выбросить ошибку "Not Found", если критично
            return
        }
        
        // 2. Применяем изменения (переносим данные из DTO в Модель)
        modifier(model, dto)
        
        // 3. Сохраняем
        try modelContext.save()
    }

    public func delete<T: PersistentModel>(
        modelType: T.Type,
        id: PersistentIdentifier
    ) throws {
        if let model = modelContext.model(for: id) as? T {
            modelContext.delete(model)
            try modelContext.save()
        }
    }
    
    public func delete<T: PersistentModel>(
        where descriptor: FetchDescriptor<T>
    ) throws {
        try modelContext.delete(model: T.self, where: descriptor.predicate)
        try modelContext.save()
    }
}
