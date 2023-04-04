//
//  MainInteracter.swift
//  ArtemTest
//
//  Created by Артём on 04.04.2023.
//

import Foundation
import Combine

protocol MenuBusinessLogic {
    func makeRequest(request: MainMenu.Model.Request.RequestType)
}

class MainInteracter: MenuBusinessLogic {
    
    var presenter: MenuPresentationLogic?
    var fetcher: DataFetcher
    
    var cancellables = Set<AnyCancellable>()
    
    init(fetchingService: DataFetcher) {
        fetcher = fetchingService
    }
    
    func makeRequest(request: MainMenu.Model.Request.RequestType) {
        switch request {

        case .getCategories:
            fetcher.getCategories().sink { [weak self] categories in
                self?.presenter?.presentData(response: .presentCategories(categories: categories))
                
                if let firstCategory = categories.first?.strCategory {
                    self?.getMeals(with: firstCategory)
                }
            }.store(in: &cancellables)
            
        case .getMeals(fromCategory: let category):
            getMeals(with: category)
        }
    }
    
    private func getMeals(with category: String) {
        fetcher.getMeals(category: category)
            .sink { [weak self] meals in
                guard let self = self else {return}
                meals.forEach { meal in
                    self.getDetails(with: meal.idMeal, meal: meal)
                }
        }.store(in: &cancellables)
    }
    
    private func getDetails(with id: String, meal: Meal) {
        fetcher.getDetails(id: id)
            .sink{ [weak self] ingredients in
                guard let details = ingredients.first else {return}
                self?.presenter?.presentData(response: .presentMeals(meal: meal, detailInfo: details))
            } .store(in: &self.cancellables)
    }

}
