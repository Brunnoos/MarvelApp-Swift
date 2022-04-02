//
//  HeroCollectionViewCell.swift
//  MarvelApp
//
//  Created by Aloc FL00030 on 01/04/22.
//

import UIKit

class HeroCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    
    static let identifier = "HeroCollectionViewCell"
    
    // MARK: - Lazy Properties
    
    lazy var heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var heroNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var heroNameBackground: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.gradientBackground(colorOne: .clear, colorTwo: .black)
        return background
    }()
    
    // MARK: - Setup Methods
    
    func setupCell(hero: Hero) {
        setupLayouts()
        setupInformation(hero: hero)
    }
    
    private func setupInformation(hero: Hero) {
        heroImageView.image = UIImage(systemName: "star")
        heroNameLabel.text = hero.name
    }
    
    // MARK: - Layout Setup Methods
    
    private func setupLayouts() {
        setupHeroImageLayout()
        setupNameBackgroundLayout()
        setupHeroNameLabelLayout()
    }
    
    private func setupHeroImageLayout() {
        addSubview(heroImageView)
        
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: self.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            heroImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupNameBackgroundLayout() {
        addSubview(heroNameBackground)
        
        NSLayoutConstraint.activate([
            heroNameBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            heroNameBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            heroNameBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            heroNameBackground.heightAnchor.constraint(equalToConstant: frame.height * 0.4)
        ])
    }
    
    private func setupHeroNameLabelLayout() {
        addSubview(heroNameLabel)
        
        NSLayoutConstraint.activate([
            heroNameLabel.topAnchor.constraint(equalTo: heroNameBackground.topAnchor),
            heroNameLabel.leadingAnchor.constraint(equalTo: heroNameBackground.leadingAnchor),
            heroNameLabel.trailingAnchor.constraint(equalTo: heroNameBackground.trailingAnchor),
            heroNameLabel.bottomAnchor.constraint(equalTo: heroNameBackground.bottomAnchor)
        ])
    }
}
