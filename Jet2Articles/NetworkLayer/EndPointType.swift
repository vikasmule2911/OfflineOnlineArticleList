//
//  EndPointType.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 09/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import Foundation
import Alamofire

typealias HTTPMethod = Alamofire.HTTPMethod
public typealias HTTPHeaders = [String: String]

protocol EndPointType {
    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

public enum HTTPTask {
    
    /// Normal Plain reuest.
    case requestPlane
    /// A requests body set with encoded parameters.
    case requestParameters(parameters: [String: Any], encoding: ParameterEncoding)
}
