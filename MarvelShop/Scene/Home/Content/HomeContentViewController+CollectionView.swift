//
//  HomeContentViewController+CollectionView.swift
//  MarvelShop
//
//  Created by Charlie
//

import UIKit


extension HomeContentViewController {

    func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) in
            let collectionViewWidth: CGFloat = UIScreen.main.bounds.size.width

            let expectInterItemSpacing = collectionViewWidth - (Design.cellMargin * 2) - (Design.cellHeight * 2)

            var interItemSpacing: CGFloat = 0
            var itemWidth: CGFloat = 0

            if expectInterItemSpacing >= Design.minimumInterItemSpacing {
                interItemSpacing = expectInterItemSpacing
                itemWidth = Design.cellWidth
            } else {
                interItemSpacing = Design.minimumInterItemSpacing
                itemWidth = (collectionViewWidth - (Design.horizontalMargin * 2) - interItemSpacing) / 2
            }

            let itemSize: NSCollectionLayoutSize = .init(
                widthDimension: .absolute(itemWidth),
                heightDimension: .fractionalHeight(1.0)
            )

            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize: NSCollectionLayoutSize = .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(Design.cellHeight)
            )

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            group.contentInsets = .init(
                top: 0,
                leading: Design.horizontalMargin,
                bottom: 0,
                trailing: Design.horizontalMargin
            )
            group.interItemSpacing = .fixed(interItemSpacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = Design.cellMargin
            section.contentInsets = .init(top: 0, leading: 0, bottom: Design.cellMargin, trailing: 0)

            return section
        }

        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)

        collectionView.register(cellWithClass: CharacterCollectionViewCell.self)
        collectionView.contentInset = .init(top: Design.verticalMargin, left: 0, bottom: Design.verticalMargin, right: 0)

        return collectionView
    }

}

extension HomeContentViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cachedModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withClass: CharacterCollectionViewCell.self, for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let model = cachedModels[safe: indexPath.item] else {
            return
        }
        let _cell = cell as? CharacterCollectionViewCell
        _cell?.setModel(model)

        let reachesBottom = indexPath.item == (self.collectionView(collectionView, numberOfItemsInSection: indexPath.section) - 1 - Design.loadMoreDistance)
        if reachesBottom {
            loadNextPublisher.send(())
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = cachedModels[safe: indexPath.item] else {
            return
        }
        characterDidTappedPublisher.send(model)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

}

private enum Design {

    static let verticalMargin: CGFloat = 20
    static let horizontalMargin: CGFloat = 10

    static let cellWidth: CGFloat = 175
    static let cellHeight: CGFloat = 255

    static let minimumInterItemSpacing: CGFloat = 20
    static let cellMargin: CGFloat = 20

    static let loadMoreDistance: Int = 1

}
