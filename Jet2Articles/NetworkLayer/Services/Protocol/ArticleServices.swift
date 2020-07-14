//
//  ArticleServices.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 09/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import Foundation

protocol ArticleServices {
    
    func getArticles(pageCount: Int, limit: Int, completion: @escaping ([Article]?, Error?) -> Void)
}
