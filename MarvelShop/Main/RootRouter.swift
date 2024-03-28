//
//  RootRouter.swift
//  MarvelShop
//
//  Created by Charlie
//

import UIKit



final class RootRouter {

    // MARK: - Properties

    weak var window: UIWindow?

    // MARK: - Initializer

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Methods

    func setupInitialRoot() {
        let vc = HomeViewController()
        let navi = UINavigationController(rootViewController: vc)

        changeRoot(navi)
    }

    private func changeRoot(_ viewController: UIViewController) {
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

}
