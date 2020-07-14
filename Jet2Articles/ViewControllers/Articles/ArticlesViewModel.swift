//
//  ArticlesViewModel.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 09/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import Foundation
import CoreData

// This protocol is used to listen server API response with completion and help to inform viewcontroller to update accordingly
protocol APIListener {
    var didReceivedSuccess: ((String) -> Void)? { get set }
    var didReceivedError: ((String) -> Void)? { get set }
}

class ArticlesViewModel: APIListener {
    
    var didReceivedSuccess: ((String) -> Void)?
    var didReceivedError: ((String) -> Void)?
    
    let articleServices: ArticleServices
    var offlineArticleFactory = OfflineArticleFactory()
    var articles: [Article] = [Article]()
    var pageCount: Int
    var isMoreRecords = true
    
    init(articleServices: ArticleServices) {
        self.articleServices = articleServices
        self.pageCount = 0
    }
    
    // Get the all articles with page and limit account
    func ready() {
        self.pageCount = self.pageCount + 1
        articleServices.getArticles(pageCount: pageCount, limit: 10) { [weak self] (response, error) in
            guard let strongSelf = self else { return }
            guard let articlesResponse = response else {
                strongSelf.didReceivedError!("request failed.")
                return
            }
            if !articlesResponse.isEmpty {
                strongSelf.articles += articlesResponse
                strongSelf.offlineArticleFactory.offlineArticles = articlesResponse
                strongSelf.saveInDB()
            } else {
                strongSelf.isMoreRecords = false
            }
            strongSelf.didReceivedSuccess!("")
        }
    }
    
    /// Save all articles data in local data base
    func saveInDB() {
        offlineArticleFactory.storeDataInDB {  [weak self] (isSuccess) in
            guard let strongSelf = self else { return }
            if isSuccess {
                strongSelf.offlineArticleFactory.offlineArticles = [Article]()
            } else {
                strongSelf.didReceivedError!("Something went wrong, please try again.")
            }
        }
    }
    
    // get all acrticle from local data i.e core data and load ui
    func fetchFromDB() {
        offlineArticleFactory.fetchDataFromDB { [weak self] (isSucsess) in
            guard let strongSelf = self else { return }
            if isSucsess {
                strongSelf.articles = offlineArticleFactory.offlineArticles
                strongSelf.didReceivedSuccess!("")
            } else {
                strongSelf.didReceivedError!("Something went wrong, please try again.")
            }
        }
    }
}
