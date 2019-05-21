//
//  MyTabBarController.swift
//  Mother
//
//  Created by Apple on 22/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabbar = UITabBar.appearance()
        
        addChildViewControllers()
    }
    
    private func setDayChildController(controller: UIViewController, imageName: String) {
        controller.tabBarItem.image = UIImage(named: imageName + "_tabbar_32x32_")
        controller.tabBarItem.selectedImage = UIImage(named: imageName + "_tabbar_press_32x32_")
    }
    
    private func addChildViewControllers() {

        setChildViewController(MapViewController(), title: "여진이 어딨어?", imageName: "mine")
        
        setChildViewController(WeatherViewController(), title: "오늘의 날씨는?", imageName: "home")

    }
    
    private func setChildViewController(_ childController: UIViewController, title: String, imageName: String) {
        setDayChildController(controller: childController, imageName: imageName)

        childController.title = title

        addChild(MyNavigationController(rootViewController: childController))
    }
    
    deinit {
    }
}

