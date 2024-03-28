//
//  SceneDelegate.swift
//  MarvelShop
//
//  Created by CHANHEE_KIM on 3/28/24.
//

import UIKit


final class SceneDelegate: NSObject {

   static var shared: SceneDelegate!

   // MARK: - Properties

   var window: UIWindow?

   private var rootRouter: RootRouter!

}

extension SceneDelegate: UIWindowSceneDelegate {

   func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       Self.shared = self

       setup(with: scene)

       start()
   }

   private func setup(with scene: UIScene) {
       guard let windowScene = (scene as? UIWindowScene) else {
           assertionFailure("Scene Initialize Failure")
           return
       }

       let _window = UIWindow(windowScene: windowScene)
       window = _window
       rootRouter = .init(window: _window)
   }

   private func start() {
       rootRouter.setupInitialRoot()
   }

}
