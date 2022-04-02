//
//  HeroDetailViewModel.swift
//  MarvelApp
//
//  Created by Aloc FL00030 on 02/04/22.
//

import Foundation
import UIKit

class HeroDetailViewModel {
    
    // MARK: - Private Properties
    private var services: HeroServiceProtocol
    private var heroID: Int
    
    // MARK: - Optional Properties
    var delegate: HeroViewModelDelegate?
    var heroes: HeroesResponse?
    var hero: Hero?
    
    // MARK: - Initialization
    
    init(heroID: Int, service: HeroServiceProtocol) {
        services = service
        self.heroID = heroID
    }
    
    // MARK: - Public Methods
    
    func fetchHero() {
        services.execute(heroID: self.heroID) { result in
            
            switch result {
            case .success(let response):
                self.onSucess(heroResponse: response)
            case .failure(let error):
                self.onFailure(error: error)
            }
            
        }
    }
    
    func getHeroID() -> Int {
        return heroID
    }
    
    func hasEvents() -> Bool {
        if  let hero = hero,
            let heroEvents = hero.events,
            let eventItems = heroEvents.items {
            
            return eventItems.count > 0
            
        } else {
            return false
        }
    }
    
    func setupHeroImage(imageView: UIImageView) {
        if let hero = hero,
           let heroThumbnail = hero.thumbnail,
           let heroThumbnailPath = heroThumbnail.path,
           let heroThumbnailExtension = heroThumbnail.thumbnailExtension {
            
            var heroThumbnailPathUpdated = heroThumbnailPath.replacingOccurrences(of: "http", with: "https")
            heroThumbnailPathUpdated = "\(heroThumbnailPathUpdated).\(heroThumbnailExtension)"
            
            if let url = URL(string: heroThumbnailPathUpdated) {
                imageView.kf.setImage(with: url)
            }
        }
        else {
            imageView.backgroundColor = UIColor.gray
        }
    }
    
    // MARK: - Private Methods
    
    private func onSucess(heroResponse: HeroesResponse) {
        self.heroes = heroResponse
        self.hero = getHero()
        delegate?.heroFetchWithSucess(isAdditional: false)
    }
    
    private func onFailure(error: HeroError) {
        print(error)
        delegate?.errorToFetchHero(error.localizedDescription)
    }
    
    private func getHero() -> Hero? {
        if let heroes = heroes,
           let heroesData = heroes.data,
           let heroesResult = heroesData.results,
           heroesResult.count > 0 {
            return heroesResult[0]
        }
        else {
            return nil
        }
    }
}
