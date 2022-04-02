//
//  EventCollectionViewCell.swift
//  MarvelApp
//
//  Created by Aloc FL00030 on 02/04/22.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static Properties
    
    static let identifier = "EventCollectionViewCell"
    
    // MARK: - Lazy Properties
    
    lazy var eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var eventNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var eventNameBackground: UIView = {
        let background = UIView()
        background.translatesAutoresizingMaskIntoConstraints = false
        background.backgroundColor = .white
        return background
    }()
    
    lazy var eventImageLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = true
        indicator.style = .medium
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Setup Methods
    
    func setupCell(event: Event) {
        setupLayouts()
        setupInformation(event: event)
    }
    
    private func setupInformation(event: Event) {
        eventNameLabel.text = event.title
        
        if let eventThumbnail = event.thumbnail,
           let eventThumbnailPath = eventThumbnail.path,
           let eventThumbnailExtension = eventThumbnail.thumbnailExtension {
            
            var eventThumbnailPathUpdated = eventThumbnailPath.replacingOccurrences(of: "http", with: "https")
            eventThumbnailPathUpdated = "\(eventThumbnailPathUpdated).\(eventThumbnailExtension)"
            
            if let url = URL(string: eventThumbnailPathUpdated) {
                eventImageLoadingIndicator.startAnimating()
                eventImageView.kf.setImage(with: url) { _ in
                    DispatchQueue.main.async {
                        self.eventImageLoadingIndicator.stopAnimating()
                    }
                }
            }
        }
        else {
            eventImageView.backgroundColor = UIColor.gray
        }
    }
    
    // MARK: - Layout Setup Methods
    
    private func setupLayouts() {
        setupEventBackgroundLayout()
        setupEventImageLayout()
        setupEventNameLabelLayout()
        setupLoadingIndicatorLayout()
    }
    
    private func setupEventImageLayout() {
        addSubview(eventImageView)
        
        NSLayoutConstraint.activate([
            eventImageView.topAnchor.constraint(equalTo: self.topAnchor),
            eventImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            eventImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            eventImageView.bottomAnchor.constraint(equalTo: eventNameBackground.topAnchor)
        ])
    }
    
    private func setupEventBackgroundLayout() {
        addSubview(eventNameBackground)
        
        NSLayoutConstraint.activate([
            eventNameBackground.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            eventNameBackground.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            eventNameBackground.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            eventNameBackground.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupEventNameLabelLayout() {
        addSubview(eventNameLabel)
        
        NSLayoutConstraint.activate([
            eventNameLabel.topAnchor.constraint(equalTo: eventNameBackground.topAnchor),
            eventNameLabel.leadingAnchor.constraint(equalTo: eventNameBackground.leadingAnchor, constant: 20),
            eventNameLabel.trailingAnchor.constraint(equalTo: eventNameBackground.trailingAnchor, constant: -20),
            eventNameLabel.bottomAnchor.constraint(equalTo: eventNameBackground.bottomAnchor)
        ])
    }
    
    private func setupLoadingIndicatorLayout() {
        addSubview(eventImageLoadingIndicator)
        
        NSLayoutConstraint.activate([
            eventImageLoadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            eventImageLoadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            eventImageLoadingIndicator.heightAnchor.constraint(equalToConstant: 40),
            eventImageLoadingIndicator.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
