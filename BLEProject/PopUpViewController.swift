//
//  PopUpViewController.swift
//  BLEProject
//
//  Created by Anh Tuan on 7/4/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import STPopup

class PopUpViewController: UIViewController {
    @IBOutlet weak var txtPress : UITextField!
    @IBOutlet weak var txtRelease : UITextField!    
    var item : ButtonData?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentSizeInPopup = CGSize(width: 300, height: 300)
        self.landscapeContentSizeInPopup = CGSize(width: 500, height: 230)
        
        self.popupController?.navigationBarHidden = true
        self.popupController?.containerView.layer.cornerRadius = 5
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PopUpViewController.dismisKeyBoard)))
    }
    
    func dismisKeyBoard(){
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.txtPress.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnOKTouchUp(_ sender : UIButton){
        TmpValue.pressText = txtPress.text ?? ""
        TmpValue.releaseText = txtRelease.text ?? ""
        TmpValue.isChange = true
        self.popupController?.dismiss()
    }
    
    @IBAction func btnCancelTouchUp(_ sender : UIButton){
        TmpValue.isChange = false
        self.popupController?.dismiss()
    }
}
