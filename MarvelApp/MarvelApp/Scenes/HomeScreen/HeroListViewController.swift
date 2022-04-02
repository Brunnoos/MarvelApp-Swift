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
            self.setupView()
        }
    }
    
    // MARK: - Private Properties
    
    private var heroesList: [Hero]?
    
    // MARK: - Public Properties
    
    var viewModel: HeroListViewModel?
    
    // MARK: - Lazy Properties
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy var heroListCollectionView: UICollectionView = {
        /// Setup Collection View Layout
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        
        let itemHeight = view.frame.height * 0.8
        let itemWidth = view.frame.width * 0.8
        collectionLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        /// Init Collection View
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        /// Register Collection View Cells
        collectionView.register(HeroCollectionViewCell.self, forCellWithReuseIdentifier: HeroCollectionViewCell.identifier)
        collectionView.register(LoadMoreCollectionViewCell.self, forCellWithReuseIdentifier: LoadMoreCollectionViewCell.identifier)
        
        collectionView.collectionViewLayout = collectionLayout
        return collectionView
    }()
    
    lazy var errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "exclamationmark.icloud")
        return imageView
    }()
    
    lazy var errorTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        viewModel?.delegate = self
        setupLayouts()
        
        heroListCollectionView.delegate = self
        heroListCollectionView.dataSource = self
        
        title = "Heróis da Marvel"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
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
        viewModel?.fetchHeroes()
    }
    
    private func fetchMoreHeroes() {
        viewModel?.fetchHeroes(listOffset: 30)
    }
    
    private func openHeroDetailsScreen(heroID: Int, heroName: String) {
        let service = HeroService()
        let viewModel = HeroDetailViewModel(heroID: heroID, service: service)
        let heroDetailViewController = HeroDetailViewController()
        
        heroDetailViewController.viewModel = viewModel
        
        navigationController?.pushViewController(heroDetailViewController, animated: true)
    }
    
    // MARK: - Private View State Methods
    
    private func onLoadingState() {
        DispatchQueue.main.async {
            self.heroListCollectionView.isHidden = true
            self.errorImageView.isHidden = true
            self.errorTextLabel.isHidden = true
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        }
    }
    
    private func onNormalState() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.errorImageView.isHidden = true
            self.errorTextLabel.isHidden = true
            self.heroListCollectionView.isHidden = false
            self.heroListCollectionView.reloadData()
        }
    }
    
    private func onErrorState() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.heroListCollectionView.isHidden = true
            self.errorImageView.isHidden = false
            self.errorTextLabel.isHidden = false
        }
    }
    
    // MARK: - Private Layout Methods
    
    private func setupLayouts() {
        setupLoadingIndicatorLayout()
        setupHeroListLayout()
        setupErrorImageLayout()
        setupErrorTextLayout()
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
    
    private func setupHeroListLayout() {
        view.addSubview(heroListCollectionView)
        
        NSLayoutConstraint.activate([
            heroListCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            heroListCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            heroListCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            heroListCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupErrorImageLayout() {
        view.addSubview(errorImageView)
        
        NSLayoutConstraint.activate([
            errorImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            errorImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            errorImageView.heightAnchor.constraint(equalToConstant: 48),
            errorImageView.widthAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupErrorTextLayout() {
        view.addSubview(errorTextLabel)
        
        NSLayoutConstraint.activate([
            errorTextLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 4),
            errorTextLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            errorTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            errorTextLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

extension HeroListViewController: HeroViewModelDelegate {
    func heroFetchWithSucess(isAdditional: Bool) {
        if let viewModel = viewModel,
           let heroesList = viewModel.getHeroesList() {
            
            if isAdditional, var selfHeroesList = self.heroesList {
                selfHeroesList.append(contentsOf: heroesList)
                self.heroesList = selfHeroesList
            }
            else {
                self.heroesList = heroesList
            }
        }
        
        self.state = .normal
    }
    
    func errorToFetchHero(_ error: String) {
        DispatchQueue.main.async {
            self.errorTextLabel.text = error
        }
        self.state = .error
    }
}

extension HeroListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: view.frame.width * 0.10, bottom: 0, right: view.frame.width * 0.10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let heroesList = heroesList {
            /// Check if Selected Row is a Hero Cell
            if indexPath.row < heroesList.count {
                if let heroName = heroesList[indexPath.row].name,
                   let heroID = heroesList[indexPath.row].id {
                    openHeroDetailsScreen(heroID: heroID, heroName: heroName)
                }
            } else {
                guard let loadMoreCell = collectionView.cellForItem(at: indexPath) as? LoadMoreCollectionViewCell else { return }
                
                loadMoreCell.startLoadingIndicator()
                fetchMoreHeroes()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let heroesList = heroesList {
            return heroesList.count + 1
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let heroesList = heroesList {
            
            if indexPath.row < heroesList.count {
                guard let heroCell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroCollectionViewCell.identifier, for: indexPath) as? HeroCollectionViewCell else { return UICollectionViewCell() }
                
                let hero = heroesList[indexPath.row]
                heroCell.setupCell(hero: hero)
                
                return heroCell
            } else {
                guard let loadMoreCell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadMoreCollectionViewCell.identifier, for: indexPath) as? LoadMoreCollectionViewCell else { return UICollectionViewCell() }
                
                loadMoreCell.stopLoadingIndicator()
                
                return loadMoreCell
            }
        }
        else {
            return UICollectionViewCell()
        }
    }
}
