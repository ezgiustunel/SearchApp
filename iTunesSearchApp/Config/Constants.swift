//
//  Constants.swift
//  iTunesSearchApp
//
//  Created by Ezgi Üstünel on 25.03.2023.
//

import Foundation

struct Constants {
    //API
    static let baseURL = "https://itunes.apple.com/"
    
    //Identifiers
}

extension Notification.Name {
    public static var ReloadImageCollectionView: Notification.Name { return self.init("notification.ReloadImageCollectionView") }
    public static var SearchAPIFailure: Notification.Name { return self.init("notification.SearchAPIFailure") }
}
