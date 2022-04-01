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

    var baseURL: String {
        return Environment.baseURL
    }

    var path: String {
        
        let timestamp = NSDate().timeIntervalSince1970.description
        
        switch self {
        case .home:
            return "limit=30&ts=\(timestamp)&apikey=\(Environment.publicKey)&hash=\(hashMD5(timestamp: timestamp))"
        case .details:
            return "details="
        }
        
    }

    var method: HTTPMethod {
            return .get
    }
}
