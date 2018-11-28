//
//  RequestModel.swift
//  IPSXNetworkingFramework
//
//  Created by Cristina Virlan on 13/02/2018.
//  Copyright © 2018 Cristina Virlan. All rights reserved.
//

import Foundation

public struct Request {
    
    public var url: String
    public var httpMethod: String
    public var contentType: String?
    public var body: Any?
    public var requestType: String?
    public var filters: [String: Any]?
    
    public init(url:String, httpMethod:String, contentType:String? = nil, body: Any? = nil, requestType: String? = nil, filters: [String: Any]? = nil) {
        
        self.url = url
        self.httpMethod = httpMethod
        self.contentType = contentType
        self.body = body
        self.requestType = requestType
        self.filters = filters
    }
}

public struct ContentType {
    
    public static let applicationJSON = "application/json"
}







