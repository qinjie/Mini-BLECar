//
//  MainViewController.swift
//  BLEProject
//
//  Created by Anh Tuan on 7/4/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import CarbonKit

class MainViewController: UIViewController {
    @IBOutlet weak var viewContent : UIView!
    let tabsName = ["Scanning", "Mobile Dectect"]
    var scanningVC : ScanningViewController?
    var controlVC : ControllerViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCarbonTabs()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initVC() {
        self.scanningVC = ScanningViewController(nibName: "ScanningViewController", bundle: nil)
        self.controlVC = ControllerViewController(nibName: "ControllerViewController", bundle: nil)
    }
    
    func initCarbonTabs() {
        self.initVC()
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: tabsName, delegate: self)
        
        carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: viewContent)
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        carbonTabSwipeNavigation.setTabBarHeight(40)
        carbonTabSwipeNavigation.setIndicatorHeight(0)
        carbonTabSwipeNavigation.carbonSegmentedControl?.backgroundColor = UIColor.init(rgba: "#E0E0E0")
        carbonTabSwipeNavigation.setNormalColor(UIColor.init(rgba: "#212121"), font: UIFont.systemFont(ofSize: 14))
        carbonTabSwipeNavigation.setSelectedColor(UIColor.init(rgba: "#304FFE"), font: UIFont.boldSystemFont(ofSize: 17))
        
        for i in 0..<tabsName.count {
            carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(UIScreen.main.bounds.width / 2, forSegmentAt: i)
        }
    }
}
extension MainViewController : CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        switch index {
        case 0:
            return self.scanningVC!
        default:
            return self.controlVC!
        }
    }
}
