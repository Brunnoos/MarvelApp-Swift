//
//  EventsService.swift
//  MarvelApp
//
//  Created by Aloc FL00030 on 02/04/22.
//

import Foundation

class EventsService: EventsServiceProtocol {
    
    let session = URLSession.shared
    
    func execute(heroID: Int, handler: @escaping (Result<EventsResponse, EventError>) -> Void) {
        let request: HomeRequest = .events
        
        if var baseURL = URLComponents(string: request.baseURL + "/\(heroID)/events") {
            
            baseURL.query = request.path
            
            guard let url = baseURL.url else { return }
            
            var requestURL = URLRequest(url: url)
            requestURL.httpMethod = request.method.name
            
            let dataTask = session.dataTask(with: requestURL) { data, response, _ in
                
                guard let httpResponse = response as? HTTPURLResponse else { return }
                
                if httpResponse.statusCode == 200 {
                    
                    do {
                        guard let jsonData = data else { return handler(.failure(.noProcessData))}
                        let decoder = JSONDecoder()
                        
                        let responseData = try decoder.decode(EventsResponse.self, from: jsonData)
                        handler(.success(responseData))
                    } catch let error {
                        handler(.failure(.error(error.localizedDescription)))
                    }
                    
                } else {
                    handler(.failure(.urlInvalid))
                }
            }
            
            dataTask.resume()
        }
    }
    
}
