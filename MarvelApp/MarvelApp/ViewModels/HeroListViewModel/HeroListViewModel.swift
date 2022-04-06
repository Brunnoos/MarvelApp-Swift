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
    private var searchServices: HeroSearchListServiceProtocol
    private var heroesLoaded: Int = 0
    
    // MARK: - Optional Properties
    var delegate: HeroViewModelDelegate?
    var heroes: HeroesResponse?
    
    // MARK: - Initialization
    
    init(service: HeroListServiceProtocol, searchServices: HeroSearchListServiceProtocol) {
        services = service
        self.searchServices = searchServices
    }
    
    // MARK: - Public Methods
    
    func fetchHeroes(listOffset: Int = 0, isStartsWith: Bool = false) {
        
        if listOffset > 0 {
            services.execute(listOffset: heroesLoaded + listOffset) { result in
                switch result {
                case .success(let response):
                    self.heroesLoaded += (response.data?.count ?? 0)
                    self.heroes = response
                    self.onSucess(heroResponse: response, isAdditional: true)
                case .failure(let error):
                    self.onFailure(error: error)
                }
            }
        } else {
            heroesLoaded = 0
            services.execute() { result in
                switch result {
                case .success(let response):
                    self.heroesLoaded += (response.data?.count ?? 0)
                    self.heroes = response
                    self.onSucess(heroResponse: response)
                case .failure(let error):
                    self.onFailure(error: error)
                }
            }
        }
        
    }
    
    func fetchHeroesSearch(search: String?, listOffset: Int = 0) {
        
        if let search = search {
            if listOffset > 0 {
                let currentOffset = heroesLoaded + listOffset
                searchServices.execute(search: search, listOffset: currentOffset) { result in
                    
                    switch result {
                    case .success(let response):
                        self.heroesLoaded += (response.data?.count ?? 0)
                        self.heroes = response
                        self.onSucess(heroResponse: response, isAdditional: true)
                        
                    case .failure(let error):
                        self.onFailure(error: error)
                    }
                }
            } else {
                searchServices.execute(search: search) { result in
                    switch result {
                    case .success(let response):
                        self.heroesLoaded = (response.data?.count ?? 0)
                        self.heroes = response
                        self.onSucess(heroResponse: response)
                        
                    case .failure(let error):
                        self.onFailure(error: error)
                    }
                }
            }
        }
        /// If no search term is provided, make a default fetch
        else {
            fetchHeroes(listOffset: listOffset)
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
    
    private func onSucess(heroResponse: HeroesResponse, isAdditional:Bool = false) {
        delegate?.heroFetchWithSucess(isAdditional: isAdditional)
    }
    
    private func onFailure(error: HeroError) {
        print(error)
        delegate?.errorToFetchHero(error.localizedDescription)
    }
    
}
