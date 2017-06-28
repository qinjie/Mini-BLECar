//
//  DisplayViewController.swift
//  BLEProject
//
//  Created by Anh Tuan on 6/28/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import CoreBluetooth
import SwiftyJSON

class DisplayViewController: UIViewController {
    
    
    var centralManager : CBCentralManager?
    var connectingPeripheral : CBPeripheral?
    var characterictist : CBCharacteristic?
    var service : CBService?
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscape
    }
    
    func createJSON(arr : [Int]) -> JSON {
        let update: JSON = [
            "Xg": arr[0],
            "Yg": arr[1],
            "Zg": arr[2],
            "Xa": arr[3],
            "Ya": arr[4],
            "Za": arr[5],
        ]
        return update
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.test()
        
        self.navigationItem.title = "HM-10"
        //set up BLE
        self.connectingPeripheral?.delegate = self
        self.connectingPeripheral?.discoverServices(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func test() {
        self.setUp()
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector((DisplayViewController.randomTest)), userInfo: nil, repeats: true).fire()
    }
    
    func randomTest() {
        let a = arc4random()
        let value = CGFloat( Int(a) % 100) / 100
    }
    
    func setUp() {
    //    viewValueX.backgroundColor = UIColor.init(rgba: "#FFC107")
    }
    
    func update(value : CGFloat, viewChild : UIView, viewParent: UIView){
        NSLog("\(value)")
        let x = viewChild.frame.origin.x
        let y = viewChild.frame.origin.y
        let height = viewChild.frame.height
        let width = viewParent.frame.width * value
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            viewChild.frame = CGRect(x: x, y: y, width: width, height: height)
        })
    }
    
    @IBAction func sendTouchUp(_ sender : UIButton){
        self.sendData(arr: [0,1,2,3,4,5])
    }
    
    func sendData(arr : [Int]) {
        if ((self.connectingPeripheral != nil) && (self.characterictist != nil)) {
            let json = self.createJSON(arr: arr)
            do {
                let data = "ABC".data(using: String.Encoding.utf8)
                self.connectingPeripheral?.writeValue(data!, for: self.characterictist!, type: CBCharacteristicWriteType.withoutResponse)
                self.connectingPeripheral?.readValue(for: self.characterictist!)
                /*
                let data = try json.rawData()
                let json = JSON.init(data: data)
                self.connectingPeripheral?.writeValue(data, for: self.characterictist!, type: CBCharacteristicWriteType.withoutResponse)
                */
                //self.connectingPeripheral?.readValue(for: self.characterictist!)
            } catch {
                NSLog("Error")
            }
        }
    }
}


extension DisplayViewController : CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        NSLog("DID WRITE")
        if (error != nil){
            NSLog("\(error?.localizedDescription)")
        } else {
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            if (thisService.uuid.uuidString.lowercased().contains(SeriveDefine.Service.lowercased())){
                peripheral.discoverCharacteristics(nil, for: thisService)
                break
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if error != nil {
            NSLog("Error \(error?.localizedDescription)")
            return
        }
        
        for characteristic in service.characteristics! {
            if (characteristic.uuid.uuidString.lowercased().contains(CharacterisTicDefine.ffe1.lowercased())){
                NSLog("Notify Cener")
                self.characterictist = characteristic
                self.connectingPeripheral?.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        NSLog("Update state Notification  \(characteristic.isNotifying)   \(characteristic.uuid.uuidString)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        NSLog("Receive")
        if (characteristic.value != nil) {
            let json = JSON.init(data: characteristic.value!)
            NSLog("\(json)")
            let a = String(data: characteristic.value!, encoding: String.Encoding.utf8)
            let arr = Array(a!.utf8)
            for item in arr {
                let a = String(data: item.data, encoding: String.Encoding.utf8)
            }
        } else {
            NSLog("NIl ha ha ")
        }
    }
}
