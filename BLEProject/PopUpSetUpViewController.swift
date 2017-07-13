//
//  PopUpSetUpViewController.swift
//  BLEProject
//
//  Created by Anh Tuan on 7/13/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import STPopup
import SwiftyJSON

class DataText {
    var title :String
    var pressText : String
    var releaseText : String
    var type = 0
    
    init(title : String, pressText : String, releaseText: String, type : Int = 0) {
        self.title = title
        self.pressText = pressText
        self.releaseText = releaseText
        self.type = type
    }
    init(json : JSON) {
        self.title = json["title"].stringValue
        self.pressText = json["pressText"].stringValue
        self.releaseText = json["releaseText"].stringValue
        self.type = json["type"].intValue
    }
}

class PopUpSetUpViewController: UIViewController {
    @IBOutlet weak var tbl : UITableView!
    var listData = [DataText]()
    var textField : UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.contentSizeInPopup = CGSize(width: 300, height: 300)
        self.landscapeContentSizeInPopup = CGSize(width: 500, height: 300)
        
        self.popupController?.navigationBarHidden = true
        self.popupController?.containerView.layer.cornerRadius = 5
        
        tbl.register(UINib.init(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCell")
        tbl.estimatedRowHeight = 100
        tbl.separatorColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let data = UserDefaults.standard.value(forKey: "DataButtonSetting")
        if (data != nil){
            self.listData.removeAll()
            let dataContent = data as? String ?? ""
            let json = JSON.init(parseJSON: dataContent)
            for item in json.array! {
                let obj = DataText.init(json: item)
                self.listData.append(obj)
            }
        }
        self.tbl.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeTouchUp(_ sender : UIButton){
        self.popupController?.dismiss()
    }
    
    func convertBtnToJSON(item : DataText) -> String {
        return "{ \"pressText\" : \"\(item.pressText)\" , \"releaseText\" : \"\(item.releaseText)\" , \"title\" : \"\(item.title)\" , \"type\" : \"\(item.type)\" }"
    }
    
    func convertDataToJSON() -> String{
        var i = 0
        var result = "["
        for item in self.listData {
            let str = self.convertBtnToJSON(item: item)
            if (i != self.listData.count - 1) {
                result = result + str + ","
            } else {
                result = result + str + "]"
            }
            i = i + 1
        }
        return result
    }
}

extension PopUpSetUpViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as! SettingTableViewCell
        cell.delegate = self
        let obj = self.listData[indexPath.row]
        cell.setData(obj: obj)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PopUpSetUpViewController : delegateSetting {
    func clickButton(item: SettingTableViewCell, id: Int) {
        let index = self.tbl.indexPath(for: item)
        let row = index?.row ?? 0
        let obj = self.listData[row]
        let alert = UIAlertController(title: "Setting", message: "Setting Value for Button", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            if ( id == 0){
                self.listData[row].pressText = self.textField?.text ?? ""
            } else {
                self.listData[row].releaseText = self.textField?.text ?? ""
            }
            let a = self.convertDataToJSON()
            self.tbl.reloadData()
            UserDefaults.standard.set(a, forKey: "DataButtonSetting")
        }))
        alert.addTextField(configurationHandler: { (textField) in
            if (id == 0){
                textField.text = obj.pressText
            } else {
                textField.text = obj.releaseText
            }
            self.textField = textField
        })
        self.present(alert, animated: true) {
        }
    }
}
