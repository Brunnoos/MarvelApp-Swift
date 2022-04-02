//
//  HeroCollectionViewCell.swift
//  MarvelApp
//
//  Created by Aloc FL00030 on 01/04/22.
//

import UIKit
import Kingfisher

class HeroCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    
    static let identifier = "HeroCollectionViewCell"
    
    // MARK: - Lazy Properties
    
    lazy var heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var heroNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var heroNameBackground: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = .white
        return background
    }()
    
    lazy var heroImageLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = true
        indicator.style = .medium
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Setup Methods
    
    func setupCell(hero: Hero) {
        setupLayouts()
        setupInformation(hero: hero)
    }
    
    private func setupInformation(hero: Hero) {
        heroNameLabel.text = hero.name
        
        if let heroThumbnail = hero.thumbnail,
           let heroThumbnailPath = heroThumbnail.path,
           let heroThumbnailExtension = heroThumbnail.thumbnailExtension {
            
            var heroThumbnailPathUpdated = heroThumbnailPath.replacingOccurrences(of: "http", with: "https")
            heroThumbnailPathUpdated = "\(heroThumbnailPathUpdated).\(heroThumbnailExtension)"
            
            if let url = URL(string: heroThumbnailPathUpdated) {
                heroImageLoadingIndicator.startAnimating()
                heroImageView.kf.setImage(with: url) { _ in
                    DispatchQueue.main.async {
                        self.heroImageLoadingIndicator.stopAnimating()
                    }
                }
            }
        }
        else {
            heroImageView.backgroundColor = UIColor.gray
        }
    }
    
    // MARK: - Layout Setup Methods
    
    private func setupLayouts() {
        setupNameBackgroundLayout()
        setupHeroImageLayout()
        setupHeroNameLabelLayout()
        setupLoadingIndicatorLayout()
    }
    
    private func setupHeroImageLayout() {
        addSubview(heroImageView)
        
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: self.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            heroImageView.bottomAnchor.constraint(equalTo: heroNameBackground.topAnchor)
        ])
    }
    
    private func setupNameBackgroundLayout() {
        addSubview(heroNameBackground)
        
        NSLayoutConstraint.activate([
            heroNameBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            heroNameBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            heroNameBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            heroNameBackground.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupHeroNameLabelLayout() {
        addSubview(heroNameLabel)
        
        NSLayoutConstraint.activate([
            heroNameLabel.topAnchor.constraint(equalTo: heroNameBackground.topAnchor),
            heroNameLabel.leadingAnchor.constraint(equalTo: heroNameBackground.leadingAnchor, constant: 20),
            heroNameLabel.trailingAnchor.constraint(equalTo: heroNameBackground.trailingAnchor, constant: -20),
            heroNameLabel.bottomAnchor.constraint(equalTo: heroNameBackground.bottomAnchor)
        ])
    }
    
    private func setupLoadingIndicatorLayout() {
        addSubview(heroImageLoadingIndicator)
        
        NSLayoutConstraint.activate([
            heroImageLoadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            heroImageLoadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            heroImageLoadingIndicator.heightAnchor.constraint(equalToConstant: 40),
            heroImageLoadingIndicator.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
