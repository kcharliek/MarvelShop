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
                itemWidth = (collectionViewWidth - (Design.cellMargin * 2) - interItemSpacing) / 2
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
                leading: Design.cellMargin,
                bottom: 0,
                trailing: Design.cellMargin
            )
            group.interItemSpacing = .fixed(interItemSpacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = Design.cellMargin
            section.contentInsets = .init(top: 0, leading: 0, bottom: Design.cellMargin, trailing: 0)

            return section
        }

        let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)

        collectionView.register(cellWithClass: CharacterCollectionViewCell.self)

        return collectionView
    }

}

private enum Design {

    static let cellWidth: CGFloat = 175
    static let cellHeight: CGFloat = 270

    static let minimumInterItemSpacing: CGFloat = 10
    static let cellMargin: CGFloat = 20

    static let loadMoreDistance: Int = 1

}
