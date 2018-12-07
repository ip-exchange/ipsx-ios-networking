//
//  Protocols.swift
//  IPSXNetworkingFramework
//
//  Created by Cristina Virlan on 28/11/2018.
//  Copyright © 2018 Cristina Virlan. All rights reserved.
//

import Foundation

public protocol QueryStringConvertible {
    
    func asQuery(urlString: String, filters: [String: Any]?) -> URL?
}

public protocol ResponseHandlingCapable {
    
    func handleResponse(statusCode: Int, errorCode: String, request: Request, data: Data?, completion: @escaping (Error?, Data?)->Void)
}

public extension ResponseHandlingCapable {
    
    func handleResponse(statusCode: Int, errorCode: String, request: Request, data: Data?, completion: @escaping (Error?, Data?)->Void) {
        
        let requestType = request.requestType ?? ""
        
        if (statusCode == 200 || statusCode == 204) && errorCode == "" {
            
            print(NSDate(),"\(requestType)" + "Request succeeded")
            completion(nil, data)
        }
        else {
            let error = RequestError.custom(statusCode, errorCode)
            print("\n")
            print(NSDate(), "Request type: \(requestType)", "ERROR:",error, "\nError Description:",error.errorDescription as Any, "\n")
            completion(error, data)
        }
    }
}

public extension QueryStringConvertible {
    
    func asQuery(urlString: String, filters: [String: Any]?) -> URL? {
        
        guard let filters = filters else { return URL(string: urlString) }
        var url = urlString
        var queries: [URLQueryItem] = []
        
        if urlString.contains("?") {
            url += "&"
        }
        else {
            url += "?"
        }
        
        for (key, value) in filters {
            if let valueString = value as? String {
                queries.append(.init(name: key, value: valueString))
            }
            else {
                queries.append(.init(name: key, value: "\(value)"))
            }
        }
        
        guard var components = URLComponents(string: "") else {
            return URL(string: url)
        }
        components.queryItems = queries
        url += components.percentEncodedQuery ?? ""
        return URL(string: url)
    }
}
