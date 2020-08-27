//
//  AppDelegate.swift
//  MetalLearnDemo
//
//  Created by 高明阳 on 2020/8/20.
//  Copyright © 2020 高明阳. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window  = UIWindow();
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window.frame = UIScreen.main.bounds;
        window.backgroundColor = UIColor.white;
//        let viewController = ViewController();
        let viewController = MetalRenderCameraController();
        let nav = UINavigationController(rootViewController: viewController);
        window.rootViewController = nav;
        window.makeKeyAndVisible();
        
        return true
    }
}

