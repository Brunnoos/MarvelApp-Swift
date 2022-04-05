//
//  HeroListViewController.swift
//  MarvelApp
//
//  Created by Aloc FL00030 on 01/04/22.
//

import UIKit

class HeroEventsViewController: UIViewController {

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
    
    private var eventsList: [Event]?
    
    // MARK: - Public Properties
    
    var viewModel: HeroEventsListViewModel?
    
    // MARK: - Lazy Properties
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy var viewTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(closeScene), for: .touchUpInside)
        return button
    }()
    
    lazy var eventsListCollectionView: UICollectionView = {
        /// Setup Collection View Layout
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        
        let itemHeight = view.frame.height * 0.7
        let itemWidth = view.frame.width * 0.8
        collectionLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        /// Init Collection View
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        /// Register Collection View Cell
        collectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: EventCollectionViewCell.identifier)
        
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
        
        view.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        viewModel?.delegate = self
        setupLayouts()
        
        eventsListCollectionView.delegate = self
        eventsListCollectionView.dataSource = self
        
        state = .loading
        
        fetchEvents()
    }
    
    @objc private func closeScene() {
        dismiss(animated: true)
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
    
    private func fetchEvents() {
        viewModel?.fetchEvents()
    }
    
    // MARK: - Private View State Methods
    
    private func onLoadingState() {
        DispatchQueue.main.async {
            self.eventsListCollectionView.isHidden = true
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
            self.eventsListCollectionView.isHidden = false
            self.eventsListCollectionView.reloadData()
        }
    }
    
    private func onErrorState() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.eventsListCollectionView.isHidden = true
            self.errorImageView.isHidden = false
            self.errorTextLabel.isHidden = false
        }
    }
    
    // MARK: - Private Layout Methods
    
    private func setupLayouts() {
        setupLoadingIndicatorLayout()
        setupViewTitleLayout()
        setupCloseButtonLayout()
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
    
    private func setupViewTitleLayout() {
        view.addSubview(viewTitle)
        
        NSLayoutConstraint.activate([
            viewTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            viewTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            viewTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            viewTitle.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupCloseButtonLayout() {
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupHeroListLayout() {
        view.addSubview(eventsListCollectionView)
        
        NSLayoutConstraint.activate([
            eventsListCollectionView.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: -10),
            eventsListCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            eventsListCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            eventsListCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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

// MARK: - View Model Delegate

extension HeroEventsViewController: HeroEventListViewModelDelegate {
    func eventsFetchWithSucess() {
        if let viewModel = viewModel,
           let eventsList = viewModel.getEventsList() {
            self.eventsList = eventsList
        }
        
        self.state = .normal
    }
    
    func errorToFetchEvents(_ error: String) {
        DispatchQueue.main.async {
            self.errorTextLabel.text = error
        }
        self.state = .error
    }
}

// MARK: - Collection Protocols

extension HeroEventsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: view.frame.width * 0.1, bottom: 0, right: view.frame.width * 0.1)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let eventsList = eventsList {
            return eventsList.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCollectionViewCell.identifier, for: indexPath) as? EventCollectionViewCell else { return UICollectionViewCell() }
        
        if let eventsList = eventsList {
            let event = eventsList[indexPath.row]
            cell.setupCell(event: event)
        }
        
        return cell
        
    }
}
