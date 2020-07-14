//
//  ArticleServiceImp.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 09/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import Foundation

enum ProviderType {
    case server
    case mock
}

class ArticlesServicesImp: ArticleServices {
    
    let provider: NetworkManager
    let providerType: ProviderType = ProviderType.server
    init(provider: NetworkManager = NetworkManager()) {
        self.provider = provider
    }
    
    func getArticles(pageCount: Int, limit: Int, completion: @escaping ([Article]?, Error?) -> Void) {
        let request = ArticleServicesAPI.getArticles(page: pageCount, pageLimit: limit)
        provider.makeRequest(endPoint: request, type: Article.self) { (response, error) in
            completion(response, error)
        }
    }
}
