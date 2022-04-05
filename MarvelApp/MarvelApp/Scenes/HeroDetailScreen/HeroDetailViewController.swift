//
//  HeroDetailViewController.swift
//  MarvelApp
//
//  Created by Aloc FL00030 on 02/04/22.
//

import Foundation
import UIKit
import Kingfisher

class HeroDetailViewController: UIViewController {

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
    
    // MARK: - Public Properties
    
    var viewModel: HeroDetailViewModel?
    
    // MARK: - Lazy Properties
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    lazy var heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    lazy var heroNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont(name: "Adventure", size: 48)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var heroDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    lazy var openEventsButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("Ver Eventos", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(openHeroEvents), for: .touchUpInside)
        return button
    }()
    
    lazy var noEventsTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Nenhum Evento encontrado"
        return label
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
        label.textAlignment = .left
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - View Controller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        viewModel?.delegate = self
        setupLayouts()
        
        title = "Detalhes do Herói"
        
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
        viewModel?.fetchHero()
    }
    
    private func setupHeroInfo(hero: Hero) {
        DispatchQueue.main.async {
            self.viewModel?.setupHeroImage(imageView: self.heroImageView)
            self.heroDescriptionLabel.text = (hero.resultDescription ?? "Sem descrição")
            self.heroNameLabel.text = hero.name
        }
    }
    
    @objc private func openHeroEvents() {
        guard let heroID = viewModel?.getHeroID() else { return }
        guard let heroName = viewModel?.hero?.name else { return }
        
        let service = EventsService()
        let viewModel = HeroEventsListViewModel(service: service, heroID: heroID)
        let heroEventsViewController = HeroEventsViewController()
        
        heroEventsViewController.viewModel = viewModel
        heroEventsViewController.viewTitle.text = "Eventos de \(heroName)"
        
        navigationController?.present(heroEventsViewController, animated: true)
    }
    
    // MARK: - Private View State Methods
    
    private func onLoadingState() {
        DispatchQueue.main.async {
            self.errorImageView.isHidden = true
            self.errorTextLabel.isHidden = true
            
            self.heroImageView.isHidden = true
            self.heroDescriptionLabel.isHidden = true
            self.openEventsButton.isHidden = true
            self.noEventsTextLabel.isHidden = true
            
            self.loadingIndicator.isHidden = false
            self.loadingIndicator.startAnimating()
        }
    }
    
    private func onNormalState() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.errorImageView.isHidden = true
            self.errorTextLabel.isHidden = true
            
            self.heroImageView.isHidden = false
            self.heroDescriptionLabel.isHidden = false
            
            if let viewModel = self.viewModel {
                
                if viewModel.hasEvents() {
                    self.openEventsButton.isHidden = false
                    self.noEventsTextLabel.isHidden = true
                } else {
                    self.openEventsButton.isHidden = true
                    self.noEventsTextLabel.isHidden = false
                }
                
            }
        }
    }
    
    private func onErrorState() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            
            self.heroImageView.isHidden = true
            self.heroDescriptionLabel.isHidden = true
            self.openEventsButton.isHidden = true
            self.noEventsTextLabel.isHidden = true
            
            self.errorImageView.isHidden = false
            self.errorTextLabel.isHidden = false
        }
    }
    
    // MARK: - Private Layout Methods
    
    private func setupLayouts() {
        setupLoadingIndicatorLayout()
        setupHeroImageLayout()
        setupOpenEventsButton()
        setupNoEventsTextLayout()
        setupHeroNameLayout()
        setupHeroDescriptionLayout()
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
    
    private func setupHeroImageLayout() {
        view.addSubview(heroImageView)
        
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            heroImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            heroImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            heroImageView.heightAnchor.constraint(equalTo: heroImageView.widthAnchor, multiplier: 0.6)
        ])
    }
    
    private func setupHeroNameLayout() {
        view.addSubview(heroNameLabel)
        
        NSLayoutConstraint.activate([
            heroNameLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 8),
            heroNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            heroNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupHeroDescriptionLayout() {
        view.addSubview(heroDescriptionLabel)
        
        NSLayoutConstraint.activate([
            heroDescriptionLabel.topAnchor.constraint(equalTo: heroNameLabel.bottomAnchor, constant: 16),
            heroDescriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            heroDescriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupOpenEventsButton() {
        view.addSubview(openEventsButton)
        
        NSLayoutConstraint.activate([
            openEventsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            openEventsButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            openEventsButton.heightAnchor.constraint(equalToConstant: 40),
            openEventsButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupNoEventsTextLayout() {
        view.addSubview(noEventsTextLabel)
        
        NSLayoutConstraint.activate([
            noEventsTextLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            noEventsTextLabel.heightAnchor.constraint(equalToConstant: 30),
            noEventsTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            noEventsTextLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
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
            errorTextLabel.topAnchor.constraint(equalTo: errorImageView.bottomAnchor, constant: 16),
            errorTextLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            errorTextLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            errorTextLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

extension HeroDetailViewController: HeroViewModelDelegate {
    func heroFetchWithSucess(isAdditional: Bool) {
        if let viewModel = viewModel,
           let hero = viewModel.hero {
            setupHeroInfo(hero: hero)
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
