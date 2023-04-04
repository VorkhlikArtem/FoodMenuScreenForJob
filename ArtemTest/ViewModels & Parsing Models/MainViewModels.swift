//
//  MainViewModel.swift
//  ArtemTest
//
//  Created by Артём on 03.04.2023.
//

import Foundation

struct MainViewModel {
    
    var meals = [MealViewModel]()
    var categories = [CategoryViewModel]()
    var banners = ["banner1", "banner2", "banner3", "banner4"]
    var location = "Moscow"
    
    var bannerItems: [Item] {
        banners.map{ Item.bannerItem(imageString: $0) }
    }
    
    var mealItems: [Item] {
        meals.map { Item.mealItem(mealViewModel: $0) }
    }
    
    
    enum Section: String, Hashable, CaseIterable {
        case bannersSection
        case mealsSection
    }
    
    enum Item : Hashable {
        case bannerItem(imageString: String  )
        case mealItem(mealViewModel: MealViewModel)
    
        func hash(into hasher: inout Hasher) {
            switch self {
            case .mealItem(let mealViewModel):
                hasher.combine(mealViewModel.id)
        
            case .bannerItem(let image):
                hasher.combine(image)
            }
        }
        
        static func == (lhs: Item, rhs: Item) -> Bool {
            switch (lhs, rhs) {
            case (.mealItem(let lMeal) , .mealItem(let rMeal)):
                return lMeal.id == rMeal.id
            case (.bannerItem(let lImage) , .bannerItem(let rImage)):
                return lImage == rImage
            default: return false
            }
        }
    }
}


// MARK: -  CategoryViewModel
struct CategoryViewModel {
    let category: String
}


// MARK: - MealViewModel
struct MealViewModel {
    let id: String
    let image: String
    let name: String
    let description: String?
    let price: String
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
        
        price = "from 3 $"
        
    }
}
