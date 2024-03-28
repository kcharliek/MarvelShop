//
//  HomeViewController.swift
//  MarvelShop
//
//  Created by Charlie
//

import UIKit


final class HomeViewController: UIViewController {

    // MARK: - Properties

    private let _tabBarController: UITabBarController = {
        let vc = UITabBarController()

        return vc
    }()

    private let searchContentViewController: HomeContentViewController = {
        let viewModel = HomeContentSearchViewModel()

        let vc = HomeContentViewController(viewModel: viewModel)

        vc.tabBarItem = .init(title: "SEARCH", image: UIImage(named: "search"), tag: 0)

        return vc
    }()

    private let favoriteContentViewController: HomeContentViewController = {
        let viewModel = HomeContentFavoriteViewModel()

        let vc = HomeContentViewController(viewModel: viewModel)

        vc.tabBarItem = .init(title: "FAVORITE", image: UIImage(named: "favorite"), tag: 1)

        return vc
    }()

    // MARK: - Initializer

    init() {
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

    }

    private func setup() {
        setupSubviews()
        setupLayout()
    }

    private func setupSubviews() {
        view.backgroundColor = .white

        _tabBarController.addChild(searchContentViewController)
        _tabBarController.addChild(favoriteContentViewController)
    }

    private func setupLayout() {
        self.addChild(_tabBarController)

        view.addSubview(_tabBarController.view)
        _tabBarController.view.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }

        _tabBarController.didMove(toParent: self)
    }

}
