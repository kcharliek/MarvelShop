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

    private let searchBar: UISearchBar = .init()
    private lazy var collectionView: UICollectionView = makeCollectionView()

    // Data
    private let viewModel: HomeContentViewModelProtocol

    // Stream
    private let viewDidLoadPublisher: PassthroughSubject<Void, Never> = .init()
    private let queryPublisher: PassthroughSubject<String, Never> = .init()
    private let refreshPublisher: PassthroughSubject<Void, Never> = .init()
    private let loadNextPublisher: PassthroughSubject<Void, Never> = .init()
    private let characterDidTappedPublisher: PassthroughSubject<MCharacter, Never> = .init()

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
    }

    private func setup() {
        setupSubviews()
        setupLayout()
    }

    private func setupSubviews() {
        view.backgroundColor = .white

        collectionView.backgroundColor = .red
    }

    private func setupLayout() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Design.searchBarHeight)
        }

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}


private enum Design {

    static let searchBarHeight: CGFloat = 55

}
