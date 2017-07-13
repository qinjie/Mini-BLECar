//
//  ControllButtonViewController.swift
//  BLEProject
//
//  Created by Anh Tuan on 7/4/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import STPopup
import SwiftyJSON
import CoreBluetooth

class ButtonData {
    var btn : UIButton
    var textPress : String
    var textRelease : String
    
    init(btn: UIButton, textPress : String, textRelease : String) {
        self.btn = btn
        self.textPress = textPress
        self.textRelease = textRelease
    }
}

class TextData {
    var textPress : String
    var textRelease : String
    init(textPress : String, textRelease : String) {
        self.textRelease = textRelease
        self.textPress = textPress
    }
    
    init(json : JSON){
        self.textPress = json["textPress"].stringValue
        self.textRelease = json["textRelease"].stringValue
    }
}

enum StatusControl {
    case Stop
    case Start
}

class ControllButtonViewController: UIViewController {
    @IBOutlet weak var btn0 : UIButton!
    @IBOutlet weak var btn1 : UIButton!
    @IBOutlet weak var btn2 : UIButton!
    @IBOutlet weak var btn3 : UIButton!
    @IBOutlet weak var btn4 : UIButton!
    @IBOutlet weak var btn5 : UIButton!
    @IBOutlet weak var btn6 : UIButton!
    @IBOutlet weak var btn7 : UIButton!
    @IBOutlet weak var btnTT : UIButton!
    
    @IBOutlet weak var viewEdit : UIView!
    @IBOutlet weak var lblPressSend : UILabel!
    @IBOutlet weak var lblReleaseSend : UILabel!
    
    @IBOutlet weak var btnStart : UIButton!
    @IBOutlet weak var slider : UISlider!
    var status : StatusControl = .Stop
    var horn : Bool = false
    
    var centralManager : CBCentralManager?
    var connectingPeripheral : CBPeripheral?
    var characterictist : CBCharacteristic?
    var service : CBService?
    
    var listBtns = [ButtonData]()
    var previousButtonData : ButtonData?
    var listData : [TextData] = []
    var image : UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSlider()
        self.hiddenDisplayData()
        self.loadData()
        
        self.centralManager?.delegate = self
        self.connectingPeripheral?.delegate = self
        self.connectingPeripheral?.discoverServices(nil)
    }
    
    func setUpSlider(){
        self.slider.addTarget(self, action: #selector(ControllButtonViewController.selectorSlider), for: UIControlEvents.valueChanged)
    }
    
    func selectorSlider(){
        NSLog("\(self.slider.value)")
        let a = Int(self.slider.value * 10)
        if ( a < 10) {
            self.sendData(str: "\(a)")
        } else {
            self.sendData(str: "q")
        }
    }
    
    @IBAction func pressHorn(_ sender : UIButton){
        self.horn = !self.horn
        self.pressHorn(status: self.horn)
    }
    
    func pressHorn(status : Bool){
        if (status == true){
            self.sendData(str: "V")
        } else {
            self.sendData(str: "v")
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscape
    }
    
    func loadData(){
        let data = UserDefaults.standard.value(forKey: "local_data")
        if (data != nil) {
            let dataContent = data as? String ?? ""
            let json = JSON.init(parseJSON: dataContent)
            for item in json.array! {
                let obj = TextData.init(json: item)
                self.listData.append(obj)
            }
        }
        self.initButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (TmpValue.isChange == true) {
            if ( self.previousButtonData != nil){
                self.previousButtonData?.textPress = TmpValue.pressText
                self.previousButtonData?.textRelease = TmpValue.releaseText
                self.displayData(item: self.previousButtonData!)
                TmpValue.isChange = false
                let data = self.convertDataToJSON()
                UserDefaults.standard.set(data, forKey: "local_data")
            }
        }
        
    }
    
    func initButton(){
        if (self.listData.count != 0) {
            self.listBtns.append(ButtonData(btn: btnTT, textPress: listData[0].textPress, textRelease: listData[0].textRelease))
            self.listBtns.append(ButtonData(btn: btn0, textPress: listData[1].textPress, textRelease: listData[1].textRelease))
            self.listBtns.append(ButtonData(btn: btn1, textPress: listData[2].textPress, textRelease: listData[2].textRelease))
            self.listBtns.append(ButtonData(btn: btn2, textPress: listData[3].textPress, textRelease: listData[3].textRelease))
            self.listBtns.append(ButtonData(btn: btn3, textPress: listData[4].textPress, textRelease: listData[4].textRelease))
            self.listBtns.append(ButtonData(btn: btn4, textPress: listData[5].textPress, textRelease: listData[5].textRelease))
            self.listBtns.append(ButtonData(btn: btn5, textPress: listData[6].textPress, textRelease: listData[6].textRelease))
            self.listBtns.append(ButtonData(btn: btn6, textPress: listData[7].textPress, textRelease: listData[7].textRelease))
            self.listBtns.append(ButtonData(btn: btn7, textPress: listData[8].textPress, textRelease: listData[8].textRelease))

        } else {
            self.listBtns.append(ButtonData(btn: btnTT, textPress: "", textRelease: ""))
            self.listBtns.append(ButtonData(btn: btn0, textPress: "", textRelease: ""))
            self.listBtns.append(ButtonData(btn: btn1, textPress: "", textRelease: ""))
            self.listBtns.append(ButtonData(btn: btn2, textPress: "", textRelease: ""))
            self.listBtns.append(ButtonData(btn: btn3, textPress: "", textRelease: ""))
            self.listBtns.append(ButtonData(btn: btn4, textPress: "", textRelease: ""))
            self.listBtns.append(ButtonData(btn: btn5, textPress: "", textRelease: ""))
            self.listBtns.append(ButtonData(btn: btn6, textPress: "", textRelease: ""))
            self.listBtns.append(ButtonData(btn: btn7, textPress: "", textRelease: ""))

        }
                var i = 0
        for item in self.listBtns {
            item.btn.tag = i
            i = i + 1
        }
        
        btnTT.addTarget(self, action: #selector(ControllButtonViewController.eventHold(_:)), for: UIControlEvents.touchDown)
        btn0.addTarget(self, action: #selector(ControllButtonViewController.eventHold(_:)), for: UIControlEvents.touchDown)
        btn1.addTarget(self, action: #selector(ControllButtonViewController.eventHold(_:)), for: UIControlEvents.touchDown)
        btn2.addTarget(self, action: #selector(ControllButtonViewController.eventHold(_:)), for: UIControlEvents.touchDown)
        btn3.addTarget(self, action: #selector(ControllButtonViewController.eventHold(_:)), for: UIControlEvents.touchDown)
        btn4.addTarget(self, action: #selector(ControllButtonViewController.eventHold(_:)), for: UIControlEvents.touchDown)
        btn5.addTarget(self, action: #selector(ControllButtonViewController.eventHold(_:)), for: UIControlEvents.touchDown)
        btn6.addTarget(self, action: #selector(ControllButtonViewController.eventHold(_:)), for: UIControlEvents.touchDown)
        btn7.addTarget(self, action: #selector(ControllButtonViewController.eventHold(_:)), for: UIControlEvents.touchDown)

        
        btnTT.addTarget(self, action: #selector(ControllButtonViewController.btnTouchUp(_:)), for: UIControlEvents.touchUpInside)
        btn0.addTarget(self, action: #selector(ControllButtonViewController.btnTouchUp(_:)), for: UIControlEvents.touchUpInside)
        btn1.addTarget(self, action: #selector(ControllButtonViewController.btnTouchUp(_:)), for: UIControlEvents.touchUpInside)
        btn2.addTarget(self, action: #selector(ControllButtonViewController.btnTouchUp(_:)), for: UIControlEvents.touchUpInside)
        btn3.addTarget(self, action: #selector(ControllButtonViewController.btnTouchUp(_:)), for: UIControlEvents.touchUpInside)
        btn4.addTarget(self, action: #selector(ControllButtonViewController.btnTouchUp(_:)), for: UIControlEvents.touchUpInside)
        btn5.addTarget(self, action: #selector(ControllButtonViewController.btnTouchUp(_:)), for: UIControlEvents.touchUpInside)
        btn6.addTarget(self, action: #selector(ControllButtonViewController.btnTouchUp(_:)), for: UIControlEvents.touchUpInside)
        btn7.addTarget(self, action: #selector(ControllButtonViewController.btnTouchUp(_:)), for: UIControlEvents.touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayData(item : ButtonData){
        if (self.status == .Stop) {
            self.viewEdit.isHidden = false
            self.lblPressSend.text = item.textPress
            self.lblReleaseSend.text = item.textRelease
            if ( self.previousButtonData?.btn != item.btn){
                self.previousButtonData?.btn.backgroundColor = UIColor.clear
                item.btn.backgroundColor = UIColor.init(rgba: "#757575")
                self.previousButtonData = item
            }
        } else {
            if ( self.previousButtonData?.btn != item.btn){
                self.previousButtonData?.btn.backgroundColor = UIColor.clear
                item.btn.backgroundColor = UIColor.init(rgba: "#757575")
                self.previousButtonData = item
            }
        }
    }
    
    func hiddenDisplayData(){
        self.viewEdit.isHidden = true
    }
    
    @IBAction func btnEdit(_ sender : UIButton) {
        //show PopupVC
        let vc = PopUpViewController(nibName: "PopUpViewController", bundle: nil)
        vc.item = self.listBtns[sender.tag]
        let stpopup = STPopupController(rootViewController: vc)
        stpopup.present(in: self)
    }
    
    func convertDataToJSON() -> String{
        var i = 0
        var result = "["
        for item in self.listBtns {
            let str = self.convertBtnToJSON(item: item)
            if (i != self.listBtns.count - 1) {
                result = result + str + ","
            } else {
                result = result + str + "]"
            }
            i = i + 1
        }
        return result
    }
    
    func convertBtnToJSON(item : ButtonData) -> String {
        return "{ \"textPress\" : \"\(item.textPress)\" , \"textRelease\" : \"\(item.textRelease)\" }"
    }
    
    func sendData(str : String) {
        NSLog("Send: \(str)")
        let b = str
        
        let data = b.data(using: String.Encoding.utf8)
        let a = self.connectingPeripheral?.maximumWriteValueLength(for: CBCharacteristicWriteType.withoutResponse)
        
        
        let countBytes = ByteCountFormatter()
        countBytes.allowedUnits = [.useBytes]
        countBytes.countStyle = .file
        let fileSize = countBytes.string(fromByteCount: Int64(data!.count))
        NSLog("Size: \(fileSize)")
        
        print("File size: \(fileSize)")
        if (data != nil){
            self.connectingPeripheral?.writeValue(data!, for: self.characterictist!, type: CBCharacteristicWriteType.withoutResponse)
        }
    }
    
    @IBAction func btnStartTouchUp(_ sender : UIButton){
        if (self.status == .Stop){
            self.sendData(str: "+CONN")
            let a = Int(self.slider.value * 10) / 6
            
            self.sendData(str: "\(a)")
            self.status = .Start
            self.viewEdit.isHidden = true
            self.btnStart.setTitle("Stop", for: .normal)
            if (self.previousButtonData != nil){
                self.previousButtonData?.btn.backgroundColor = UIColor.clear
                self.previousButtonData = nil
            }
        } else {
            self.sendData(str: "+DISC")
            self.status = .Stop
            self.previousButtonData = nil
            self.btnStart.setTitle("Start to Run", for: .normal)
            self.viewEdit.isHidden = false
            
        }
    }
    
    func btnTouchUp(_ sender : UIButton){
        if (status == .Stop){
            self.displayData(item: self.listBtns[sender.tag])
        } else if (status == .Start){
            self.sendData(str: "S")
//            let a = self.previousButtonData?.textRelease ?? ""
//            if ( a != ""){
//                self.sendData(str: a)
//            }
        }
    }
    
    func eventHold(_ sender: UIButton){
        if (status == .Start){
            self.previousButtonData = self.listBtns[sender.tag]
            let a = self.previousButtonData?.textPress ?? ""
            if ( a != ""){
                self.sendData(str: a)
            }
        }
        
    }
}

extension ControllButtonViewController : CBCentralManagerDelegate {
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if (error != nil) {
            let alertVC = UIAlertController(title: "Warning", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
                self.centralManager?.cancelPeripheralConnection(self.connectingPeripheral!)
            }
            alertVC.addAction(alertAction)
            self.show(alertVC, sender: nil)
        }
        
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let uuid = CBUUID.init(string: CharacterisTicDefine.ffe1)
        if (central.retrieveConnectedPeripherals(withServices: [uuid])).count == 0 {
            
            let alertVC = UIAlertController(title: "Warning", message: "Disconnected", preferredStyle: UIAlertControllerStyle.alert)
            self.show(alertVC, sender: nil)
        }
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
    }
    
}

extension ControllButtonViewController : CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            NSLog("Services: \(service.uuid.uuidString)")
            let thisService = service as CBService
            if (thisService.uuid.uuidString.lowercased().contains(SeriveDefine.Service.lowercased())){
                peripheral.discoverCharacteristics(nil, for: thisService)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if error != nil {
            NSLog("Error \(error?.localizedDescription)")
            return
        }

        for characteristic in service.characteristics! {
            NSLog("Characteristic of (\(service.uuid.uuidString))" + characteristic.uuid.uuidString)
            if (characteristic.uuid.uuidString.lowercased().contains(CharacterisTicDefine.ffe1.lowercased())){
                NSLog("Notify Cener")
                self.connectingPeripheral?.setNotifyValue(true, for: characteristic)
                self.characterictist = characteristic
                break
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        NSLog("Update state Notification  \(characteristic.isNotifying)   \(characteristic.uuid.uuidString)")
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let a = String.init(data: characteristic.value!, encoding: String.Encoding.ascii)
        NSLog("Receive:   \(a)")
    }
}


