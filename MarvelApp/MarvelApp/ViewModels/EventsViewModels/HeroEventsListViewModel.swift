//
//  EventsListViewModel.swift
//  MarvelApp
//
//  Created by Aloc FL00030 on 02/04/22.
//

import Foundation

class HeroEventsListViewModel {
    
    // MARK: - Private Properties
    private var services: EventsServiceProtocol
    private var heroID: Int
    
    // MARK: - Optional Properties
    var delegate: HeroEventListViewModelDelegate?
    var events: EventsResponse?
    
    // MARK: - Initialization
    
    init(service: EventsServiceProtocol, heroID: Int) {
        services = service
        self.heroID = heroID
    }
    
    // MARK: - Public Methods
    
    func fetchEvents() {
        services.execute(heroID: heroID) { result in
            
            switch result {
            case .success(let response):
                self.onSucess(eventsResponse: response)
            case .failure(let error):
                self.onFailure(error: error)
            }
            
        }
    }
    
    func getEventsList() -> [Event]? {
        if let events = events,
           let eventsData = events.data {
            return eventsData.results
        }
        else {
            return nil
        }
    }
    
    // MARK: - Private Methods
    
    private func onSucess(eventsResponse: EventsResponse) {
        self.events = eventsResponse
        delegate?.eventsFetchWithSucess()
    }
    
    private func onFailure(error: EventError) {
        print(error)
        delegate?.errorToFetchEvents(error.localizedDescription)
    }
    
}
