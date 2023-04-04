//
//  MainTabController.swift
//  ArtemTest
//
//  Created by Артём on 04.04.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .pink
        tabBar.unselectedItemTintColor = #colorLiteral(red: 0.7651259899, green: 0.7696109414, blue: 0.7867208719, alpha: 1)
        tabBar.backgroundColor = .white
        setupTabBar()
    }
    
    private func setupTabBar() {
        let mainViewController = buildMainVC()
        
        let mainNC = generateNavigationController(rootViewController: mainViewController,
                                                  title: "Меню",
                                                  image: "Menu")
        
        let contactsNC = generateNavigationController(rootViewController: UIViewController(),
                                                      title: "Контакты",
                                                      image: "Contacts")
        
        let profileNC = generateNavigationController(rootViewController: UIViewController(),
                                                     title: "Профиль",
                                                     image: "Profile")
        
        let cartNC = generateNavigationController(rootViewController: UIViewController(),
                                                  title: "Корзина",
                                                  image: "Cart")
        
        viewControllers = [mainNC, contactsNC, profileNC, cartNC]
    }
    
    private func buildMainVC() -> UIViewController {
        let dataFetcher           = CombineNetworkManager()
        
        let viewController        = MainViewController()
        let interactor            = MainInteracter(fetchingService: dataFetcher)
        let presenter             = MainPresenter()
        viewController.interactor = interactor
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        
        return viewController
    }
    
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = UIImage(named: image)
        return navigationVC
    }
        
}
