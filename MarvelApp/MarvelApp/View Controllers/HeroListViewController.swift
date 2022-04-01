//
//  HeroListViewController.swift
//  MarvelApp
//
//  Created by Aloc FL00030 on 01/04/22.
//

import UIKit

class HeroListViewController: UIViewController {

    // MARK: - Fileprivate Properties
    
    fileprivate enum ViewState {
        case loading
        case normal
        case error
    }
    
    fileprivate var state: ViewState = .loading {
        didSet {
            
        }
    }
    
    // MARK: - Public Properties
    
    var viewModel: HeroListViewModel?
    
    // MARK: - Lazy Properties
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        return indicator
    }()
    
    lazy var heroListCollectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        viewModel?.delegate = self

        state = .loading
        
        fetchHeroes()
    }
    
    // MARK: - Private Setup Methods
    
    private func setupView() {
        switch state {
        case .loading:
            onLoadingState()
        case .normal:
            onNormalState()
        case .error:
            onErrorState()
        }
    }
    
    private func fetchHeroes() {
        
    }
    
    // MARK: - Private View State Methods
    
    private func onLoadingState() {
        heroListCollectionView.isHidden = true
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    private func onNormalState() {
        
    }
    
    private func onErrorState() {
        
    }
    
    // MARK: - Private Layout Methods
    
    private func setupLayouts() {
        setupLoadingIndicatorLayout()
    }
    
    private func setupLoadingIndicatorLayout() {
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 100),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}

extension HeroListViewController: HeroListViewModelDelegate {
    func heroFetchWithSucess() {
        
    }
    
    func errorToFetchHero(_ error: String) {
        
    }
    
    
}
