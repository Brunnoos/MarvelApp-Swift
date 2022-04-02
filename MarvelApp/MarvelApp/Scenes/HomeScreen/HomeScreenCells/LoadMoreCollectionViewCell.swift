//
//  LoadMoreCollectionViewCell.swift
//  MarvelApp
//
//  Created by Aloc FL00030 on 02/04/22.
//

import UIKit

class LoadMoreCollectionViewCell: UICollectionViewCell {
    // MARK: - Static Properties
    
    static let identifier = "LoadMoreCollectionViewCell"
    
    // MARK: - Lazy Properties
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "plus.circle")
        return imageView
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Carregar Mais"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = true
        indicator.style = .large
        indicator.color = .white
        return indicator
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .darkGray
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
        imageView.isHidden = false
        textLabel.isHidden = false
        setupLayouts()
    }
    
    init() {
        super.init(frame: .zero)
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func startLoadingIndicator() {
        DispatchQueue.main.async {
            self.imageView.isHidden = true
            self.textLabel.isHidden = true
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        }
    }
    
    func stopLoadingIndicator() {
        DispatchQueue.main.async {
            self.imageView.isHidden = false
            self.textLabel.isHidden = false
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.stopAnimating()
        }
    }
    
    // MARK: - Layout Setup Methods
    
    private func setupLayouts() {
        setupImageLayout()
        setupTextLabelLayout()
        setupLoadingIndicatorLayout()
    }
    
    private func setupImageLayout() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func setupTextLabelLayout() {
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant:  5),
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
        ])
    }
    
    private func setupLoadingIndicatorLayout() {
        addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 40),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
