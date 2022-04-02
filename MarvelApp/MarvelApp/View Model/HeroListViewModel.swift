//
//  HeroViewModel.swift
//  MarvelApp
//
//  Created by Aloc FL00030 on 01/04/22.
//

import Foundation

class HeroListViewModel {
    
    // MARK: - Private Properties
    private var services: HeroListServiceProtocol
    
    // MARK: - Optional Properties
    var delegate: HeroListViewModelDelegate?
    var heroes: HeroesResponse?
    
    // MARK: - Initialization
    
    init(service: HeroListServiceProtocol) {
        services = service
    }
    
    // MARK: - Public Methods
    
    func fetchHeroes() {
        services.execute() { result in
            
            switch result {
            case .success(let response):
                self.onSucess(heroResponse: response)
            case .failure(let error):
                self.onFailure(error: error)
            }
            
        }
    }
    
    func getHeroesList() -> [Hero]? {
        if let heroes = heroes,
           let heroesData = heroes.data {
            return heroesData.results
        }
        else {
            return nil
        }
    }
    
    // MARK: - Private Methods
    
    private func onSucess(heroResponse: HeroesResponse) {
        self.heroes = heroResponse
        delegate?.heroFetchWithSucess()
    }
    
    private func onFailure(error: HeroError) {
        print(error)
        delegate?.errorToFetchHero(error.localizedDescription)
    }
    
}
