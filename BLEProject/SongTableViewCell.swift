//
//  SongTableViewCell.swift
//  BLEProject
//
//  Created by Anh Tuan on 7/21/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import MediaPlayer

class SongTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblAuthor : UILabel!
    @IBOutlet weak var imgThumb : UIImageView!
    @IBOutlet weak var lblTime : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSongs(obj : MPMediaItem){
        self.lblTitle.text = obj.title ?? ""
        self.lblAuthor.text = obj.artist ?? ""
    }
}
