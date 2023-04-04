//
//  MainPresenter.swift
//  ArtemTest
//
//  Created by Артём on 04.04.2023.
//

import Foundation

protocol MenuPresentationLogic {
    func presentData(response: MainMenu.Model.Response.ResponseType)
}

class MainPresenter: MenuPresentationLogic {
    
    weak var viewController: MenuDisplayLogic?
    
    func presentData(response: MainMenu.Model.Response.ResponseType) {
        switch response {
  
        case .presentCategories(categories: let categories):
            
            let categoryViewModels = categories.map {
                CategoryViewModel(category: $0.strCategory)
            }
            viewController?.displayData(viewModel: .displayCategories(categoryViewModels: categoryViewModels))
            
        case .presentMeals(let meal, let detailInfo):
            
            let mealViewModel = MealViewModel(from: meal, and: detailInfo)
            viewController?.displayData(viewModel: .displayMeals(mealViewModel: mealViewModel))
        }
    }
}

