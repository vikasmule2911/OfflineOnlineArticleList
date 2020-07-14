//
//  NetworkManager.swift
//  Jet2Articles
//
//  Created by Vikas Mule on 09/07/20.
//  Copyright © 2020 Vikas Mule. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkProtocol {
    
    func makeRequest<T: Codable>(endPoint: URLRequestConvertible,
                                 type: T.Type,
                                 completion: ((_ response: [T]?, _ error: Error?) -> Void)?)
    
    func downloadImage(url: URL, completion: @escaping (Data?, Error?) -> Void)
}

class NetworkManager: NetworkProtocol {
    
    func makeRequest<T>(endPoint: URLRequestConvertible,
                        type: T.Type,
                        completion: (([T]?, Error?) -> Void)?) where T : Decodable, T : Encodable {
        print("Request : \(endPoint)")
        AF.request(endPoint)
            .responseJSON { (response) in
                DispatchQueue.main.async {
                    switch response.result {
                    case .success :
                        guard let jsonData = response.data else { return }
                        do {
                            let decoder = JSONDecoder()
                            let responseObject = try decoder.decode([T].self, from: jsonData)
                            print(responseObject)
                            completion!(responseObject, nil)
                        } catch let errorMessage {
                            print(errorMessage)
                            completion!(nil, errorMessage)
                        }
                    case .failure :
                        print(response.error ?? "Request Failed")
                        completion!(nil, response.error)
                    }
                }
        }
    }
    
    /// downloadImage function will download the thumbnail images
    /// returns Result<Data> as completion handler
    func downloadImage(url: URL,
                       completion: @escaping (Data?, Error?) -> Void) {
        
        AF.download(url)
            .responseData { response in
                DispatchQueue.main.async() {
                    switch response.result {
                    case .success(let data):
                        completion(data, nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
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
