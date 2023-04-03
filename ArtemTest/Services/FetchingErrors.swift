//
//  FetchingErrors.swift
//  ArtemTest
//
//  Created by Артём on 03.04.2023.
//

import Foundation

enum DataFetchingError: Error, LocalizedError {
    case invalidUrl
    case serverResponseError
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid URL"
        case .serverResponseError:
            return "Error from server"
        case .decodingError:
            return "Error while parsing"
        }
    }
}
