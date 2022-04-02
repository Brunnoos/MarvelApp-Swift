//
//  EventServiceProtocols.swift
//  MarvelApp
//
//  Created by Aloc FL00030 on 02/04/22.
//

import Foundation

enum EventError: Error {
    case error(String)
    case urlInvalid
    case noDataAvailable
    case noProcessData
}

protocol EventsServiceProtocol: AnyObject {
    func execute(heroID: Int, handler: @escaping(Result<EventsResponse, EventError>) -> Void)
}
