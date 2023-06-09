//
//  NetworkManager.swift
//  ArtemTest
//
//  Created by Артём on 03.04.2023.
//

import Foundation
import Combine

protocol DataFetcher {
    func getCategories() -> AnyPublisher<[Category], Never>
    func getMeals(category: String) -> AnyPublisher<[Meal], Never>
    func getDetails(id: String) -> AnyPublisher<[Detail], Never>
}

final class CombineNetworkManager: DataFetcher {
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }

    func getCategories() -> AnyPublisher<[Category], Never> {
        Just(())
            .compactMap {
                url(from: API.listPath, params: ["c": "list"])
            }
            .flatMap { url in
                self.fetchData( url: url, type: CategoryResponse.self)
            }
            .map{$0.meals}
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getMeals(category: String) -> AnyPublisher<[Meal], Never> {
        guard let url = url(from: API.filterPath, params: ["c": category]) else {
            return Just([]).eraseToAnyPublisher()
        }
        return fetchData( url: url, type: MealResponse.self)
            .map{$0.meals}
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getDetails(id: String) -> AnyPublisher<[Detail], Never> {
        Just(())
            .compactMap {
                url(from: API.ingredientsPath, params: ["i": id])
            }
            .flatMap { url in
                self.fetchData( url: url, type: DetailsResponse.self)
            }
            .map{$0.meals}
            .replaceError(with: [] )
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    
    
    // MARK: - Generic Method for Network Data Fetching
    private func fetchData<T: Decodable>(url: URL, type: T.Type) -> AnyPublisher<T, Error> {
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                    throw DataFetchingError.serverResponseError
                }
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .mapError {
                $0 is DecodingError ? DataFetchingError.decodingError : $0
            }
            .eraseToAnyPublisher()
    }
    
    private func url(from path: String, params: [String:String]) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        components.queryItems = params.map{ URLQueryItem(name: $0, value: $1) }
        
        return components.url
        
    }
}
