//
//  HeroListService.swift
//  MarvelApp
//
//  Created by Aloc FL00030 on 01/04/22.
//

import Foundation

class HeroListService: HeroListServiceProtocol {
    
    let session = URLSession.shared
    
    func execute(handler: @escaping (Result<HeroesResponse, HeroError>) -> Void) {
        let request: HomeRequest = .home
        
        if var baseURL = URLComponents(string: request.baseURL) {
            
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
                        
                        let responseData = try decoder.decode(HeroesResponse.self, from: jsonData)
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
    
    func execute(listOffset: Int, handler: @escaping (Result<HeroesResponse, HeroError>) -> Void) {
        let request: HomeRequest = .home
        
        if var baseURL = URLComponents(string: request.baseURL) {
            
            baseURL.query = "offset=\(listOffset)&" + request.path
            
            guard let url = baseURL.url else { return }
            
            var requestURL = URLRequest(url: url)
            requestURL.httpMethod = request.method.name
            
            let dataTask = session.dataTask(with: requestURL) { data, response, _ in
                
                guard let httpResponse = response as? HTTPURLResponse else { return }
                
                if httpResponse.statusCode == 200 {
                    
                    do {
                        guard let jsonData = data else { return handler(.failure(.noProcessData))}
                        let decoder = JSONDecoder()
                        
                        let responseData = try decoder.decode(HeroesResponse.self, from: jsonData)
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
