//
//  APIRouter.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import Foundation

enum APIRouter {
    case search(term: String)
    
    var request: URLRequest {
        var components = URLComponents(string: baseUrl)!
        components.path = path
        components.queryItems = queryComponents
        
        let url = components.url!
        return URLRequest(url: url)
    }
    
    private var baseUrl: String {
        return Constants.baseURL
    }
    
    private var path: String {
        switch self {
        case .search: return "/search"
        }
    }
    
    private struct ParameterKeys {
        static let term = "term"
        static let media = "media"
    }
    
    private struct DefaultValues {
        static let term = "apple"
        static let media = "software"
    }
    
    private var parameters: [String: Any] {
        switch self {
        case .search(let term):
            let parameters: [String: Any] = [
                ParameterKeys.term : term,
                ParameterKeys.media : DefaultValues.media
            ]
            return parameters
        }
    }
    
    private var queryComponents: [URLQueryItem] {
        var components = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.append(queryItem)
        }
        return components
    }
}
