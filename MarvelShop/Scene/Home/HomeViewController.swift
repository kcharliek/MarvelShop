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

    private lazy var searchContentViewController: HomeContentViewController = {
        let vc = HomeContentViewController(viewModel: searchContentViewModel)

        vc.tabBarItem = .init(title: "SEARCH", image: UIImage(named: "search"), tag: 0)

        return vc
    }()
    @Inject("search") private var searchContentViewModel: HomeContentViewModelProtocol

    private lazy var favoriteContentViewController: HomeContentViewController = {
        let vc = HomeContentViewController(viewModel: favoriteContentViewModel)

        vc.tabBarItem = .init(title: "FAVORITE", image: UIImage(named: "favorite"), tag: 1)

        return vc
    }()
    @Inject("favorite") private var favoriteContentViewModel: HomeContentViewModelProtocol

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

#if DEBUG
        navigationItem.rightBarButtonItem = .init(title: "DEBUG", style: .plain, target: self, action: #selector(debugButtonDidTapped))
#endif
    }

#if DEBUG
    @objc
    private func debugButtonDidTapped() {
        let vc = DebugViewController()
        let navi = UINavigationController(rootViewController: vc)
        self.present(navi, animated: true)
    }
#endif

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
