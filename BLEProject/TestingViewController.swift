//
//  TestingViewController.swift
//  BLEProject
//
//  Created by Anh Tuan on 6/27/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import CoreBluetooth
class TestingViewController: UIViewController {
    var centralManager : CBCentralManager?
    var connectingPeripheral : CBPeripheral?
    var characterictist : CBCharacteristic?
    var service : CBService?
    
    @IBOutlet weak var txtInput : UITextField!
    @IBOutlet weak var lblResult : UILabel!
    @IBOutlet weak var btnButton : UIButton!
    
    var index = 0
    var textSend = ""
    var result = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(connectingPeripheral?.name ?? "N/A")"
        self.connectingPeripheral?.delegate = self
        
        self.connectingPeripheral?.discoverServices(nil)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TestingViewController.endEditting)))
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSendTouchUp(_ sender : UIButton){
        self.result = ""
        index = 0
        self.textSend = self.txtInput.text ?? "" + "\0"
        self.lblResult.text = ""
        if ((self.characterictist != nil) && (self.connectingPeripheral != nil)){
            let data = self.textSend.data(using: String.Encoding.utf8)
            self.connectingPeripheral?.writeValue(data!, for: self.characterictist!, type: CBCharacteristicWriteType.withoutResponse)
        }
         
    }
    
    func endEditting(gesture : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    @IBAction func clearTouchUp(_ sender : UIButton){
        self.txtInput.text = ""
    }
}

extension TestingViewController : CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        NSLog("DID WRITE")
        if (error != nil){
            NSLog("\(error?.localizedDescription)")
        } else {
            
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        NSLog("Discover_____Services")
        for service in peripheral.services! {
            let thisService = service as CBService
            NSLog("Service-------------- \(thisService.uuid)   -   \(thisService.uuid.uuidString)")
            if (thisService.uuid.uuidString.lowercased().contains(SeriveDefine.Service.lowercased())){ //Temperature
                NSLog("------------------ Find to Discover")
                peripheral.discoverCharacteristics(nil, for: thisService)
                break
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        NSLog("-------------DidDiscoverCharacteris")
        if error != nil {
            NSLog("Error \(error?.localizedDescription)")
            return
        }
        
        for characteristic in service.characteristics! {
            NSLog("Characteristic------------\(characteristic.uuid.uuidString)")
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
            let a = String(data: characteristic.value!, encoding: String.Encoding.utf8)
            let arr = Array(a!.utf8)
            for item in arr {
                
                let a = String(data: item.data, encoding: String.Encoding.utf8)
                self.result = self.result + a!
            }
            self.lblResult.text = self.result
        }
    }
}
extension String {
    subscript (i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
}
// Data Extensions:
protocol DataConvertible {
    init(data:Data)
    var data:Data { get }
}

extension DataConvertible {
    init(data:Data) {
        guard data.count == MemoryLayout<Self>.size else {
            fatalError("data size (\(data.count)) != type size (\(MemoryLayout<Self>.size))")
        }
        self = data.withUnsafeBytes { $0.pointee }
    }
    
    var data:Data {
        var value = self
        return Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
}

extension UInt8:DataConvertible {}
extension UInt16:DataConvertible {}
extension UInt32:DataConvertible {}
extension Int32:DataConvertible {}
extension Int64:DataConvertible {}
extension Double:DataConvertible {}
extension Float:DataConvertible {}
