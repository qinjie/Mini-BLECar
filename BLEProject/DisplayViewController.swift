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
    
    @IBOutlet weak var viewXg: UIView!
    @IBOutlet weak var viewValueXg: UIView!
    
    @IBOutlet weak var viewYg: UIView!
    @IBOutlet weak var viewValueYg: UIView!
    
    @IBOutlet weak var viewZg: UIView!
    @IBOutlet weak var viewValueZg: UIView!
    
    @IBOutlet weak var viewXa: UIView!
    @IBOutlet weak var viewValueXa: UIView!
    
    @IBOutlet weak var viewYa: UIView!
    @IBOutlet weak var viewValueYa: UIView!
    
    @IBOutlet weak var viewZa: UIView!
    @IBOutlet weak var viewValueZa: UIView!

    var result = ""
    var centralManager : CBCentralManager?
    var connectingPeripheral : CBPeripheral?
    var characterictist : CBCharacteristic?
    var service : CBService?
    
    var ArrayMain : [Int] = []
    var ArrayResult : [CGFloat] = []
    var currentIndex = 0
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
        
        self.centralManager?.delegate = self
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
        let x = viewChild.frame.origin.x
        let y = viewChild.frame.origin.y
        let height = viewChild.frame.height
        let width = viewParent.frame.width * value
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            viewChild.frame = CGRect(x: x, y: y, width: width, height: height)
        })
    }
    
    @IBAction func sendTouchUp(_ sender : UIButton){
        var a : [Int] = []
        for _ in 0 ..< 6 {
            let rand = Int.random(from: 100, to: 65535)            
            a.append(Int(rand))
        }
        self.sendData(arr: a)
    }
    
    @IBAction func closeTouchUp(_ sender : UIButton){
        self.dismiss(animated: true) { 
            
        }
    }
    
    func sendData(arr : [Int]) {
        self.ArrayResult.removeAll()
        self.result = ""
        self.ArrayMain = arr
        for i in arr {
            NSLog("Send: \(i)")
        }
        if ((self.connectingPeripheral != nil) && (self.characterictist != nil)) {
            self.currentIndex = 0
            self.sendAtIndex(index: 0)
        }
    }
    
    func sendAtIndex(index: Int) {
        if index > 5 {
            self.displayValue(arr: self.ArrayResult)
            NSLog("------------------------------------------------------------------------")
            return
        }
        var score = ArrayMain[index]
        let data2 = NSData(bytes: &score, length: 8)
        self.connectingPeripheral?.writeValue(data2 as Data, for: self.characterictist!, type: CBCharacteristicWriteType.withoutResponse)
    }
    
    func displayValue(arr : [CGFloat]){
        self.update(value: CGFloat(arr[0]), viewChild: viewValueXg, viewParent: viewXg)
        self.update(value: CGFloat(arr[1]), viewChild: viewValueYg, viewParent: viewYg)
        self.update(value: CGFloat(arr[2]), viewChild: viewValueZg, viewParent: viewZg)
        self.update(value: CGFloat(arr[3]), viewChild: viewValueXa, viewParent: viewXa)
        self.update(value: CGFloat(arr[4]), viewChild: viewValueYa, viewParent: viewYa)
        self.update(value: CGFloat(arr[5]), viewChild: viewValueZa, viewParent: viewZa)
    }
}

extension DisplayViewController : CBCentralManagerDelegate {
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let alertVC = UIAlertController(title: "Warning", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(alertAction)
        self.show(alertVC, sender: nil)
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

extension DisplayViewController : CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if (error != nil){
            let alertVC = UIAlertController(title: "Warning", message: "\(error?.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
            self.show(alertVC, sender: nil)
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
                break
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        NSLog("Update state Notification  \(characteristic.isNotifying)   \(characteristic.uuid.uuidString)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        NSLog("Receive")
        if (characterictist?.value != nil) {
            let data = characterictist?.value as? NSData
            var num = 0
            data?.getBytes(&num, length: 8)
            NSLog("Num: \(num)")
            self.ArrayResult.append(CGFloat(num) / CGFloat(65535))
            self.currentIndex = self.currentIndex + 1
            self.sendAtIndex(index: self.currentIndex)
//------------------------------------------------------------------------------------------------
//            self.result = self.result + (a ?? "")
//            if (self.result.contains("\n")) {
//                NSLog("Result: \(self.result)")
//                self.result = self.result.replacingOccurrences(of: "\n", with: "")
//                let arr = self.result.components(separatedBy: " ")
//                
//                var arrValue : [CGFloat] = []
//                for item in arr {
//                    arrValue.append(CGFloat(Int(item) ?? 0) / CGFloat(65535) )
//                }
//                self.result = ""
//                self.displayValue(arr: arrValue)
//                } else {
//            }
//------------------------------------------------------------------------------------------------
        } else {
            NSLog("NIl Value")
        }
        
    }
    
}


public extension Int {
    static func random(from: Int, to: Int) -> Int {
        guard to > from else {
            assertionFailure("Can not generate negative random numbers")
            return 0
        }
        return Int(arc4random_uniform(UInt32(to - from)) + UInt32(from))
    }
}
