//
//  RequestManager.swift
//  IPSXNetworkingFramework
//
//  Created by Cristina Virlan on 13/02/2018.
//  Copyright © 2018 Cristina Virlan. All rights reserved.
//
import Foundation

public class RequestManager: NSObject, URLSessionDelegate, ResponseHandlingCapable {
    
    public static let shared = RequestManager()
    private override init() {}
    
    public var session : URLSession {
        get {
            let urlconfig = URLSessionConfiguration.default
            urlconfig.timeoutIntervalForRequest = 30
            urlconfig.timeoutIntervalForResource = 30
            return URLSession(configuration: urlconfig, delegate: self, delegateQueue: nil)
        }
    }
    
    public func executeRequest(request: Request, completion:@escaping (Error?, Data?)->Void) {
        
        let requestManager = RequestManager.shared
        if let urlRequest = requestManager.createUrlRequest(request: request) {
            
            requestManager.session.dataTask(with: urlRequest , completionHandler: { data, response, error in
                
                if let error = error {
                    completion(error, data)
                }
                else if let httpResponse = response as? HTTPURLResponse {
                    
                    let statusCode = httpResponse.statusCode
                    let errorCode = errorString(forHttpResponse: httpResponse)
                    self.handleResponse(statusCode: statusCode, errorCode: errorCode, request: request, data: data, completion: completion)
                }
            }).resume()
        }
    }
    
    fileprivate func createUrlRequest(request: Request)-> URLRequest? {
        
        var urlRequest: URLRequest?
        var postData: Data?
        
        if let body = request.body as? JSON, body.count != 0 {
            do {
                postData = try body.rawData()
            } catch {
                print("Error getting Data from JSON body")
            }
        }
        
        if let url = URL(string: request.url) {
            
            urlRequest = URLRequest(url: url)
            urlRequest?.httpMethod = request.httpMethod
            urlRequest?.httpBody = postData
            
            if let contentType = request.contentType {
                urlRequest?.setValue(contentType, forHTTPHeaderField: "Content-Type")
            }
        }
        return urlRequest
    }
}
