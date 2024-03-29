//
//  DebugViewController.swift
//  MarvelShop
//
//  Created by Charlie
//

#if DEBUG

import UIKit


enum DebugMenu: Int, CaseIterable {

    case network

    var title: String {
        "🌐 Network Debugger"
    }

}

final class DebugViewController: UIViewController {

    // MARK: - Properties

    private lazy var collectionView: UICollectionView = makeCollectionView()

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
        title = "DEBUG"
        view.backgroundColor = .white

        collectionView.dataSource = self
        collectionView.delegate = self

        navigationItem.rightBarButtonItem = .init(title: "CLOSE", style: .done, target: self, action: #selector(closeButtonDidTapped))
    }

    @objc
    private func closeButtonDidTapped() {
        dismiss(animated: true)
    }

    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) in
            let itemSize: NSCollectionLayoutSize = .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )

            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize: NSCollectionLayoutSize = .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(Design.cellHeight)
            )

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)

            return section
        }

        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)

        collectionView.register(cellWithClass: DebugCollectionViewCell.self)

        return collectionView
    }

}

extension DebugViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        DebugMenu.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: DebugCollectionViewCell.self, for: indexPath)

        cell.setTitle(DebugMenu.allCases[indexPath.item].title)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menu = DebugMenu.allCases[indexPath.item]

        switch menu {
        case .network:
            let vc = DebugNetworkViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

private enum Design {

    static let cellHeight: CGFloat = 55

}

#endif
