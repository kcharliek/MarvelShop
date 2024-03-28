//
//  AppDelegate.swift
//  MarvelShop
//
//  Created by Charlie
//

import UIKit


@UIApplicationMain
final class AppDelegate: NSObject {

    static var shared: AppDelegate!

}

extension AppDelegate: UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        Self.shared = self

        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)

        sceneConfig.delegateClass = SceneDelegate.self

        return sceneConfig
    }

}
