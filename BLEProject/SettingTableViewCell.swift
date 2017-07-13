//
//  SettingTableViewCell.swift
//  BLEProject
//
//  Created by Anh Tuan on 7/13/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

protocol delegateSetting {
    func clickButton(item : SettingTableViewCell, id : Int)
}


class SettingTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var btnPress : UIButton!
    @IBOutlet weak var btnRelease : UIButton!
    var delegate : delegateSetting?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(obj : DataText){
        lblTitle.text = obj.title
        if ( obj.pressText == ""){
            self.btnPress.setTitle("none", for: UIControlState.normal)
            self.btnPress.setTitleColor(UIColor.red, for: UIControlState.normal)
        } else {
            self.btnPress.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.btnPress.setTitle(obj.pressText, for: UIControlState.normal)
        }
        if (obj.releaseText == ""){
            self.btnRelease.setTitle("none", for: UIControlState.normal)
            self.btnRelease.setTitleColor(UIColor.red, for: UIControlState.normal)
        } else {
            self.btnRelease.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.btnRelease.setTitle(obj.releaseText, for: UIControlState.normal)
        }
        if (obj.type == 1){
            self.btnRelease.isHidden = true
        } else {
            self.btnRelease.isHidden = false
        }
    }
   
    @IBAction func btnPressTouch(_ sender : UIButton){
        if (delegate != nil){
            delegate?.clickButton(item: self, id: 0)
        }
    }
    
    @IBAction func btnReleaseTouch(_ sender : UIButton){
        if (delegate != nil){
            delegate?.clickButton(item: self, id: 1)
        }
    }
    
}
