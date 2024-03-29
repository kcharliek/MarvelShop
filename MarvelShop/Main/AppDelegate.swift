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

    var launchOptions: [UIApplication.LaunchOptionsKey: Any]!

}

extension AppDelegate: UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        Self.shared = self
        self.launchOptions = launchOptions

#if ON_SAMPLE
        print("🛠️🛠️ PROJECT IS RUNNING ON SAMPLE 🛠️🛠️")
#endif

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
