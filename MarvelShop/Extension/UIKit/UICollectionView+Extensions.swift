//
//  UICollectionView+Extensions.swift
//  MarvelShop
//
//  Created by Charlie
//

import UIKit


extension UICollectionView {

    func register<T: UICollectionViewCell>(cellWithClass name: T.Type) {
        register(T.self, forCellWithReuseIdentifier: String(describing: name))
    }

    func dequeueReusableCell<T: UICollectionViewCell>(withClass name: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: name), for: indexPath) as? T else {
            fatalError("FATAL - Register UICollectionViewCell Named \(name)")
        }
        return cell
    }

    func dequeueEmptyCell(for indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "EMPTY_COLLECTIONVIEW_CELL"
        
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: identifier)

        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }

}
