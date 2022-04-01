//
//  HeroViewModelDelegate.swift
//  MarvelApp
//
//  Created by Aloc FL00030 on 01/04/22.
//

import Foundation

protocol HeroListViewModelDelegate: AnyObject {
    
    func heroFetchWithSucess()
    func errorToFetchHero(_ error: String)
    
}
