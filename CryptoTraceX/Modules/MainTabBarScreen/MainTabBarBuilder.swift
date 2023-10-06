//
//  MainTabBarBuilder.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 30.08.2023.
//

import UIKit

final class MainTabBarBuilder: Presentable {
    
    func toPresent() -> UIViewController {
        let tabBarController = MainTabBarViewController()
        return tabBarController
    }
}
