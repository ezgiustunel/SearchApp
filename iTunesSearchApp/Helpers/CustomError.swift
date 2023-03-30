//
//  CustomError.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import Foundation

enum CustomError: Int {
    case unknownError = -1
    
    private var message: String {
        switch self {
        case .unknownError:
            return "error_unknown"
        }
    }
    
    var error: Error {
        return NSError(domain: "iTunesSearch", code: self.rawValue, userInfo: [NSLocalizedDescriptionKey : message])
    }
    
    static func errorWithMessage(message: String?) -> Error {
        if let message = message {
            return NSError(domain: "iTunesSearch", code: -1, userInfo: [NSLocalizedDescriptionKey : message])
        }
        return CustomError.unknownError.error
    }
}
