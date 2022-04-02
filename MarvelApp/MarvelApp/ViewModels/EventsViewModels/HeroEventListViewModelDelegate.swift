//
//  EventViewModelDelegate.swift
//  MarvelApp
//
//  Created by Aloc FL00030 on 02/04/22.
//

import Foundation

protocol HeroEventListViewModelDelegate: AnyObject {
    
    func eventsFetchWithSucess()
    func errorToFetchEvents(_ error: String)
    
}
