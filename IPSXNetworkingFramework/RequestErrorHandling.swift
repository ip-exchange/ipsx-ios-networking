//
//  RequestErrorHandling.swift
//  IPSXNetworkingFramework
//
//  Created by Cristina Virlan on 26/10/2018.
//  Copyright © 2018 Cristina Virlan. All rights reserved.
//

import Foundation

protocol ResponseHandlingCapable {
    
    func handleResponse(statusCode: Int, errorCode: String, request: Request, data: Data?, completion: @escaping (Error?, Data?)->Void)
}

extension ResponseHandlingCapable {
    
    func handleResponse(statusCode: Int, errorCode: String, request: Request, data: Data?, completion: @escaping (Error?, Data?)->Void) {
        
        let requestType = request.requestType ?? ""
        
        if statusCode == 200 && errorCode == "" {
            
            print(NSDate(),"\(requestType)" + "Request succeeded")
            completion(nil, data)
        }
        else {
            let error = RequestError.custom(statusCode, errorCode)
            print("\n")
            print(NSDate(), "Request type: \(requestType)", "ERROR:",error, "\nError Description:",error.localizedDescription, "\n")
            completion(error, data)
        }
    }
}

public enum ServiceResult<T> {
    
    case success(T)
    case failure(Error)
}

public enum RequestError: Error {
    
    case custom(Int, String)
    case noData
    
    public var errorDescription: String? {
        
        switch self {
            
        case .noData:
            return "There was no data on the server response."
           
        case .custom(let statusCode, let errorCode):
            return "Error status code: " + "\(statusCode)" + " and error code: " + "\(errorCode)"
        }
    }
}

public struct ErrorCode {
    
    public static let failureType1 = "FAIL"
    public static let failureType2 = "FAIL2"
}

///Parse custom http error code
public func errorString(forHttpResponse response: HTTPURLResponse) -> String {
    
    let statusCode = response.statusCode
    
    if statusCode == 200 {
        return ""
    }
    else {
        //update implementation based on custom http response
        return ErrorCode.failureType1
    }
}









