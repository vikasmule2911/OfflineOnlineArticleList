//
//  OfflineArticleFetcher.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 14/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import Foundation

protocol OfflineFetcher {
    func storeDataInDB(completion: (_ success: Bool) -> Void)
    func fetchDataFromDB(completion: (_ success: Bool) -> Void)
}

class OfflineArticleFactory: OfflineFetcher {
    
    var offlineArticle = [Article]()
    
    init() {}
    
    func storeDataInDB(completion: (Bool) -> Void) {
        
    }
    
    func fetchDataFromDB(completion: (Bool) -> Void) {
        
    }
}
extension OfflineArticleFactory
