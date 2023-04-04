//
//  MainModel.swift
//  ArtemTest
//
//  Created by Артём on 04.04.2023.
//

import Foundation

enum MainMenu {
    enum Model {
        struct Request {
            enum RequestType {
                case getCategories
                case getMeals(fromCategory: String)
            }
        }
        struct Response {
            enum ResponseType {
                case presentCategories(categories: [Category])
                case presentMeals(meal: Meal, detailInfo: Detail )
            }
        }
        struct ViewModel {
            enum ViewModelData {
                
                case displayCategories(categoryViewModels: [CategoryViewModel])
                case displayMeals(mealViewModel: MealViewModel )
            }
        }
    }
}
