//
//  MainModel.swift
//  ArtemTest
//
//  Created by Артём on 03.04.2023.
//

import Foundation

struct MainModel{
    var meals = [MealViewModel]()
    var categories = [Category]()
    var banners = ["banner1", "banner2", "banner3", "banner4"]
}


struct MealViewModel {
    let id: String
    let image: String
    let name: String
    let description: String?
}

extension MealViewModel {
    init(from meal: Meal, and detail: Detail) {
        id = meal.idMeal
        image = meal.strMealThumb
        name = meal.strMeal
        
        description = [detail.strIngredient1, detail.strIngredient2, detail.strIngredient3,
                           detail.strIngredient4, detail.strIngredient5, detail.strIngredient6,
                           detail.strIngredient7, detail.strIngredient8, detail.strIngredient9,
                           detail.strIngredient10
        ].compactMap{$0}.filter{!$0.isEmpty}.joined(separator: ", ")
        
    }
}
