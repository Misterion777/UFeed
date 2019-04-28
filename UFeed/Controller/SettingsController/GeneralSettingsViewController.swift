//
//  GeneralViewController.swift
//  UFeed
//
//  Created by Ilya on 4/26/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import SideMenuSwift

class GeneralSettingsViewController : SettingsViewController {
    
    var isDarkModeEnabled = false
    var themeColor = UIColor.white
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "General"
        
        isDarkModeEnabled = SideMenuController.preferences.basic.position == .under
        configureUI()
//        setNeedsStatusBarAppearanceUpdate()
    }
    
//    @IBAction func menuButtonDidClicked(_ sender: Any) {
//        sideMenuController?.revealMenu()
//    }
    
    private func configureUI() {

//        if isDarkModeEnabled {
//            themeColor = .mirage
//            statusBarBehaviorSegment.tintColor = .lobolly
//            menuPositionSegment.tintColor = .lobolly
//            menuDirectionSegment.tintColor = .lobolly
//            orientationSegment.tintColor = .lobolly
//            for label in indicatorLabels {
//                label.textColor = .white
//            }
//            navigationController?.navigationBar.isTranslucent = false
//            navigationController?.navigationBar.tintColor = .lobolly
//            navigationController?.navigationBar.barTintColor = .mirage
//            navigationController?.navigationBar.titleTextAttributes = [
//                NSAttributedString.Key.foregroundColor: UIColor.white
//            ]
//        } else {
//            themeColor = .white
//        }
//
//        view.backgroundColor = themeColor
//        containerView.backgroundColor = themeColor
//
//        let preferences = SideMenuController.preferences.basic
//        guard let behaviorIndex = statusBarBehaviors.firstIndex(of: preferences.statusBarBehavior) else {
//            fatalError("Conigration is messed up")
//        }
//        statusBarBehaviorSegment.selectedSegmentIndex = behaviorIndex
//
//        guard let menuPositionIndex = menuPosition.firstIndex(of: preferences.position) else {
//            fatalError("Conigration is messed up")
//        }
//        menuPositionSegment.selectedSegmentIndex = menuPositionIndex
//
//        guard let menuDirectionIndex = menuDirections.firstIndex(of: preferences.direction) else {
//            fatalError("Conigration is messed up")
//        }
//        menuDirectionSegment.selectedSegmentIndex = menuDirectionIndex
//
//        guard let menuOrientationIndex = menuOrientation.firstIndex(of: preferences.supportedOrientations)else {
//            fatalError("Conigration is messed up")
//        }
//        orientationSegment.selectedSegmentIndex = menuOrientationIndex
    }
}


