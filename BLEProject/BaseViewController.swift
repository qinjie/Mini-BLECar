//
//  BaseViewController.swift
//  BLEProject
//
//  Created by Anh Tuan on 6/23/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLoadingHUD() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.backgroundColor = UIColor.gray
        hud.tintColor = UIColor.gray
        hud.contentColor = UIColor.gray
        hud.bezelView.color = UIColor.gray
        hud.bezelView.style = .solidColor
    }
    
    func hideLoadingHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
        //MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }
}
