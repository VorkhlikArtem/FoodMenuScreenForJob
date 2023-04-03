//
//  MainViewModel.swift
//  ArtemTest
//
//  Created by Артём on 03.04.2023.
//

import Foundation

enum MainViewModel {
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
