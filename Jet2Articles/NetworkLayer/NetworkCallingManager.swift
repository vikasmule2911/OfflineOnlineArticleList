//
//  NetworkManager.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 09/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkCallProtocol {
    
   func makeRequest<T: Codable>(endPoint: URLRequestConvertible,
                            type: T.Type,
                            completion: ((_ response: T?, _ error: Error?) -> Void)?)
}

class NetworkManager: NetworkCallProtocol {
    
    func makeRequest<T>(endPoint: URLRequestConvertible,
                        type: T.Type,
                        completion: ((T?, Error?) -> Void)?) where T : Decodable, T : Encodable {
        
        AF.request(endPoint)
            .validate(contentType: ["application/json"])
            .response { response in
                switch response.result {
                case .success:
                    guard let jsonData = response.data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let responseObject = try decoder.decode(T.self, from: jsonData)
                        print(responseObject)
                        DispatchQueue.main.async { completion!(responseObject, nil) }
                    } catch let errorMessage {
                        print("success failure: \(errorMessage)")
                        completion!(nil, errorMessage)
                    }
                case let .failure(error):
                    let error = response.response.flatMap({ (responseData) -> CustomError? in
                        switch responseData.statusCode {
                        case 401:
                            return .unAthorized
                        case 501, 500:
                            return .internalServerError
                        case 503:
                            return .serviceUnavailable
                        default:
                            return .requestTimeOut
                        }
                    })
                    print(error ?? Localized.Common.requestFailed)
                    DispatchQueue.main.async { completion!(nil, error) }
                }
        }
    }
}


public enum CustomError: Error {
    
    case unAthorized
    //Something unexpected happed at server end.
    case internalServerError
    
    //Time Out.
    case requestTimeOut
    
    ///when we are unable to fetch data from server or connect to server it is problem from server side.
    case serviceUnavailable
    
    var errorDescription: String {
        switch self {
        case .unAthorized: return "Token got expired."
        case .internalServerError: return "Server Communication Error."
        case .requestTimeOut: return "Request Time Out."
        case .serviceUnavailable: return "Typically, this can be due to a temporary overloading or maintenance of the server."
        }
    }
}
