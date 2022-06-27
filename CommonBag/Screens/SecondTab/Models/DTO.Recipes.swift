//
//  DTO.Recipes.swift
//  CommonBag
//
//  Created by MikhailSeregin on 24.06.2022.
//

import Foundation

extension DTO {
    struct CategoryRs: Codable, Identifiable, Hashable {
        /// Идентификатор категории
        let id: UUID
        /// Название категории
        let title: String
        /// Ссылка на картинку
        let imagePath: String
    }
    
    struct RecipeRs: Codable, Identifiable, Hashable {
        /// Идентификатор рецепта
        let id: UUID
        /// Название рецепта
        let title: String
        /// Описание рецепта
        let summary: String?
        /// Способ приготовления
        let steps: String?
        ///Ссылка на картинку
        let imagePath: String?
        
        let products: [RecipeProductRs]?
    }
    
    struct RecipeProductRs: Codable, Identifiable, Hashable {
        /// Идентификатор продукта
        let id: UUID
        /// Название продукта
        let title: String
        /// Количество продукта
        let count: String?
    }
}
