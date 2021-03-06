//
//  TabBarCoordinator.swift
//  Five
//
//  Created by Key Hoffman on 7/26/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import Foundation
import UIKit
import PopupDialog

// MARK: - TabBarCoordinatorDelegate Protocol


protocol MainTabBarCoordinatorDelegate: class {

}

// MARK: - MainTabBarCoordinator

final class MainTabBarCoordinator: Coordinator, DiscoverCoordinatorDelegate, CalenderCoordinatorDelegate, ProfileCoordinatorDelegate, CreateEventCoordinatorDelegate, MainTabBarViewModelCoordinatorDelegate {
    
    // MARK: - TabBarCoordinatorDelegate Declaration
    
    weak var coordinatorDelegate: MainTabBarCoordinatorDelegate?
    
    // MARK: - Root Property Declarations
    
    private let window: UIWindow
    private let rootViewController: MainTabController
    
    private let mainTabBarViewModel: MainTabBarViewModelType
    
    private let discoverCoordinator:    DiscoverCoordinator
    private let calenderCoordinator:    CalenderCoordinator
    private let profileCoordinator:     ProfileCoordinator
    private let createEventCoordinator: CreateEventCoordinator
    
    private let discoverNavigationController    = UINavigationController()
    private let calenderNavigationController    = UINavigationController()
    private let profileNavigationController     = UINavigationController()
    private let createEventNavigationController = UINavigationController()
    
    init(window: UIWindow, user: User) {
        self.window = window
        
        mainTabBarViewModel = MainTabBarViewModel()
        
        discoverNavigationController.tabBarItem    = MainTabBarStyleSheet.TabBarItem.Discover.tabBarItem
        calenderNavigationController.tabBarItem    = MainTabBarStyleSheet.TabBarItem.Calender.tabBarItem
        profileNavigationController.tabBarItem     = MainTabBarStyleSheet.TabBarItem.Profile.tabBarItem
        createEventNavigationController.tabBarItem = MainTabBarStyleSheet.TabBarItem.CreateEvent.tabBarItem
        
        let viewControllers = [discoverNavigationController, calenderNavigationController, profileNavigationController, createEventNavigationController].setTabBarItemTags()
        
        rootViewController = MainTabController(viewControllers: viewControllers)
        
        rootViewController.viewModel = mainTabBarViewModel
        
        discoverCoordinator    = DiscoverCoordinator(navigationController: discoverNavigationController)
        calenderCoordinator    = CalenderCoordinator(navigationController: calenderNavigationController)
        profileCoordinator     = ProfileCoordinator(navigationController: profileNavigationController, user: user)
        createEventCoordinator = CreateEventCoordinator(navigationController: createEventNavigationController)
        
        mainTabBarViewModel.coordinatorDelegate = self
        
        discoverCoordinator.coordinatorDelegate    = self
        calenderCoordinator.coordinatorDelegate    = self
        profileCoordinator.coordinatorDelegate     = self
        createEventCoordinator.coordinatorDelegate = self
    }
    
    func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        discoverCoordinator.start()
//        calenderCoordinator.start()
//        profileCoordinator.start()
//        createEventCoordinator.start()
    }
    
    func anErrorHasOccured(errorMessage: String) {
        let errorPopup = PopupDialog(title: "Error", message: errorMessage)
        ErrorPopoverStyleSheet.Prepare(errorPopup)
        rootViewController.presentViewController(errorPopup, animated: true, completion: nil)
    }
    
    func userDidSelecTab(atIndex index: Int) {
        switch index {
        case 0: discoverCoordinator.start()
        case 1: calenderCoordinator.start()
        case 2: profileCoordinator.start()
//        case 3: createEventCoordinator.start()
        default: anErrorHasOccured("Invalid selection")
        }
    }
    
}
















