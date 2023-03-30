//
//  HomeString.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 30.03.2023.
//

import Foundation

enum HomeString: String {
    case searchSomething
    case noData
    
    var localized: String {
        NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
    }
}
