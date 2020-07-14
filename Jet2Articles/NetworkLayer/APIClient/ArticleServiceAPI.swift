//
//  ArticleServiceAPI.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 09/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import Foundation
import Alamofire

enum ArticleServicesAPI {
    case getArticles(page: Int, pageLimit: Int)
}

extension ArticleServicesAPI: EndPointType, URLRequestConvertible {
    
    var baseURL: String {
        return "https://5e99a9b1bc561b0016af3540.mockapi.io/jet2/"
    }
    
    var path: String {
        switch self {
        case let .getArticles(page, pageLimit) :
            return "api/v1/blogs?page=\(page)&limit=\(pageLimit)"
        }
    }
    
    var httpMethod: HTTPMethod {
       return .get
    }
    
    var task: HTTPTask {
        .requestPlane
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }
    
    func asURLRequest() throws -> URLRequest {
        let baseServiceURL: URL =  URL(string: baseURL + path)!
        
        let url = try baseServiceURL.asURL()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        
        switch task {
        case .requestPlane :
            urlRequest = try URLEncoding.default.encode(urlRequest, with: [:])
        case let .requestParameters(parameters, _) :
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        }
        return urlRequest
    }

}
