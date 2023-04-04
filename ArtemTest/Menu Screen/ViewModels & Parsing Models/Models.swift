//
//  Model.swift
//  ArtemTest
//
//  Created by Артём on 03.04.2023.
//

import Foundation

struct MealResponse: Decodable {
    let meals: [Meal]
}

struct Meal: Decodable, Equatable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
}

struct CategoryResponse: Decodable {
    let meals: [Category]
}

struct Category: Decodable {
    let strCategory: String
}

struct DetailsResponse: Decodable {
    let meals: [Detail]
}

struct Detail: Decodable, Equatable {
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    
}

