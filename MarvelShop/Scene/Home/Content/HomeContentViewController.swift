//
//  HomeContentViewController.swift
//  MarvelShop
//
//  Created by Charlie
//

import UIKit
import Combine


final class HomeContentViewController: UIViewController {
    
    // MARK: - Properties

    // UI
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.axis = .vertical
        stackView.spacing = 0

        return stackView
    }()
    private let searchBar: UISearchBar = {
        let _searchBar = UISearchBar()

        _searchBar.placeholder = "마블 영웅 이름을 입력하시오."
        _searchBar.returnKeyType = .done

        return _searchBar
    }()
    private lazy var collectionView: UICollectionView = makeCollectionView()
    private let loadingIndicator: UIActivityIndicatorView = .init(style: .large)
    private let refreshControl = UIRefreshControl()
    private let emptyLabel: UILabel = {
        let label = UILabel()

        label.text = "조회된 내용이 없습니다."
        label.textColor = Design.emptyLabelTextColor
        label.font = Design.emptyLabelFont

        return label
    }()

    // Data
    private let viewModel: HomeContentViewModelProtocol
    private(set) var cachedCharacters: [MCharacter] = []
    private(set) var cachedFavoriteCharacterIds: [Int] = []

    // Stream
    private let viewDidLoadPublisher: PassthroughSubject<Void, Never> = .init()
    private let queryPublisher: PassthroughSubject<String, Never> = .init()
    private let refreshPublisher: PassthroughSubject<Void, Never> = .init()
    private(set) var loadNextPublisher: PassthroughSubject<Void, Never> = .init()
    private(set) var characterDidTappedPublisher: PassthroughSubject<MCharacter, Never> = .init()

    private var cancelBag: Set<AnyCancellable> = .init()

    // MARK: - Initializer

    init(viewModel: HomeContentViewModelProtocol) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        bind()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("DO NOT USE WITH INTERFACE BUILDER")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        viewDidLoadPublisher.send(())
    }

    // MARK: - Methods

    private func bind() {
        let output = viewModel.transform(
            .init(
                viewDidLoad: viewDidLoadPublisher.eraseToAnyPublisher(),
                query: queryPublisher.eraseToAnyPublisher(),
                refresh: refreshPublisher.eraseToAnyPublisher(),
                loadNext: loadNextPublisher.eraseToAnyPublisher(),
                characterDidTapped: characterDidTappedPublisher.eraseToAnyPublisher()
            )
        )

        output.presenting
            .shouldEnableSearch
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] shows in
                self.searchBar.isHidden = (shows == false)
            }
            .store(in: &cancelBag)

        output.presenting
            .shouldEnableRefresh
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] shows in
                shows ? self.setupRefreshControl() : ()
            }
            .store(in: &cancelBag)

        Publishers.CombineLatest(
            output.presenting.characters,
            output.presenting.favoriteCharacterIds
        )
        .receive(on: DispatchQueue.main)
        .sink { [unowned self] (characters, favoriteCharacterIds) in
            self.cachedCharacters = characters
            self.cachedFavoriteCharacterIds = favoriteCharacterIds

            self.emptyLabel.isHidden = (characters.isEmpty == false)
            self.collectionView.reloadData()
        }
        .store(in: &cancelBag)

        output.presenting
            .isLoading
            .withUnretained(self)
            .receive(on: DispatchQueue.main)
            .sink { (owner, isLoading) in
                if isLoading {
                    owner.loadingIndicator.startAnimating()
                } else {
                    if owner.refreshControl.isRefreshing {
                        owner.refreshControl.endRefreshing()
                    }
                    owner.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancelBag)
    }

    private func setup() {
        setupSubviews()
        setupLayout()
    }

    private func setupSubviews() {
        view.backgroundColor = .white
        setupCollectionView()
    }

    private func setupCollectionView() {
        searchBar.delegate = self

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func setupRefreshControl() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
    }

    @objc
    private func refreshControlTriggered() {
        refreshPublisher.send(())
    }

    private func setupLayout() {
        view.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        mainStackView.addArrangedSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(Design.searchBarHeight)
        }

        mainStackView.addArrangedSubview(collectionView)

        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        loadingIndicator.hidesWhenStopped = true

        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}

extension HomeContentViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        queryPublisher.send(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}

private enum Design {

    static let searchBarHeight: CGFloat = 55

    static let emptyLabelTextColor: UIColor = .lightGray
    static let emptyLabelFont: UIFont = .systemFont(ofSize: 15)

}
