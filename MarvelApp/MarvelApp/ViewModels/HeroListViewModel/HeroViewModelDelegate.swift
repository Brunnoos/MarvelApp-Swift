//
//  HeroViewModelDelegate.swift
//  MarvelApp
//
//  Created by Aloc FL00030 on 01/04/22.
//

import Foundation

protocol HeroViewModelDelegate: AnyObject {
    
    func heroFetchWithSucess(isAdditional: Bool)
    func errorToFetchHero(_ error: String)
    
}
