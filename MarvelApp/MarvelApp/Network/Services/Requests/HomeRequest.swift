//
//  HomeRequest.swift
//  MarvelApp
//
//  Created by Aloc FL00030 on 01/04/22.
//

import Foundation

enum HomeRequest: URLRequestProtocol {
    case home
    case details
    case events

    var baseURL: String {
        return Environment.baseURL
    }

    var path: String {
        
        let timestamp = NSDate().timeIntervalSince1970.description
        
        switch self {
        case .home:
            return "ts=\(timestamp)&apikey=\(Environment.publicKey)&hash=\(hashMD5(timestamp: timestamp))"
        case .details, .events:
            return "ts=\(timestamp)&apikey=\(Environment.publicKey)&hash=\(hashMD5(timestamp: timestamp))"
        }
        
    }

    var method: HTTPMethod {
            return .get
    }
}
