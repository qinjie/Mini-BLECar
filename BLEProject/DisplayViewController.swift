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
    
    let epsion = CGFloat(0.05)
    
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblResultTemp : UILabel!
    @IBOutlet weak var tempDecimal : UILabel!
    
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
    
    
    @IBOutlet weak var lblXg : UILabel!
    @IBOutlet weak var lblYg : UILabel!
    @IBOutlet weak var lblZg : UILabel!
    
    @IBOutlet weak var lblXa : UILabel!
    @IBOutlet weak var lblYa : UILabel!
    @IBOutlet weak var lblZa : UILabel!
    
    @IBOutlet weak var btn0 : UIButton!
    @IBOutlet weak var btn1 : UIButton!
    @IBOutlet weak var btn2 : UIButton!
    @IBOutlet weak var btn3 : UIButton!
    @IBOutlet weak var btn4 : UIButton!
    @IBOutlet weak var btn5 : UIButton!
    @IBOutlet weak var btn6 : UIButton!
    @IBOutlet weak var btn7 : UIButton!
    @IBOutlet weak var btnTT : UIButton!
    
    var arrBtn = [UIButton]()
    var previousBtn : UIButton?

    var result = ""
    var centralManager : CBCentralManager?
    var connectingPeripheral : CBPeripheral?
    var characterictist : CBCharacteristic?
    var service : CBService?
    
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
    
    func initToArray() {
        arrBtn.append(btn0)
        arrBtn.append(btn1)
        arrBtn.append(btn2)
        arrBtn.append(btn3)
        arrBtn.append(btn4)
        arrBtn.append(btn5)
        arrBtn.append(btn6)
        arrBtn.append(btn7)
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
        UIView.animate(withDuration: 1/30, animations: { () -> Void in
            viewChild.frame = CGRect(x: x, y: y, width: width, height: height)
        })
    }
    
    @IBAction func sendTouchUp(_ sender : UIButton){
        var a : [Int] = []
        for _ in 0 ..< 6 {
            let rand = Int.random(from: 100, to: 65535)            
            a.append(Int(rand))
        }     
    }
    
    @IBAction func closeTouchUp(_ sender : UIButton){
        self.dismiss(animated: true) { 
            self.centralManager?.cancelPeripheralConnection(self.connectingPeripheral!)
        }
    }
    
    func clearAll(){
        
    }
    
    func displayValue(arr : [CGFloat]){
        let xA = arr[0]
        let yA = arr[1]
        
        if ((xA <= 0.25 + epsion) && (xA >= 0.0 + epsion)) { //DOWN
            if (( yA >= 0.75 + epsion) && (yA <= 1 - epsion)){ //left
                if (self.previousBtn != btn5){
                    self.previousBtn?.backgroundColor = UIColor.white
                    btn5.backgroundColor = UIColor.red
                    self.previousBtn = btn5
                }
            } else if ( (yA >= 0 + epsion ) && (yA <= 0.25 - epsion)) { //right
                if (self.previousBtn != btn3){
                    self.previousBtn?.backgroundColor = UIColor.white
                    btn3.backgroundColor = UIColor.red
                    self.previousBtn = btn3
                }
            } else {
                if (self.previousBtn != btn4) {
                    self.previousBtn?.backgroundColor = UIColor.white
                    btn4.backgroundColor = UIColor.red
                    self.previousBtn = btn4
                }
            }
        } else if ((xA >= 0.75 + epsion) && (xA <= 1 - epsion)) {//back //UP
            if (( yA >= 0.75 + epsion) && (yA <= 1 - epsion)){ //left
                if (self.previousBtn != btn7) {
                    self.previousBtn?.backgroundColor = UIColor.white
                    btn7.backgroundColor = UIColor.red
                    self.previousBtn = btn7
                }
            } else if ( (yA >= 0 + epsion ) && (yA <= 0.25 - epsion)) { //right
                if (self.previousBtn != btn1) {
                    self.previousBtn?.backgroundColor = UIColor.white
                    btn1.backgroundColor = UIColor.red
                    self.previousBtn = btn1
                }
            } else {
                if (self.previousBtn != btn0) {
                    self.previousBtn?.backgroundColor = UIColor.white
                    btn0.backgroundColor = UIColor.red
                    self.previousBtn = btn0
                }
            }
        } else {
            if (( yA >= 0.75 + epsion) && (yA <= 1 - epsion)){ //left
                if (self.previousBtn != btn6) {
                    self.previousBtn?.backgroundColor = UIColor.white
                    btn6.backgroundColor = UIColor.red
                    self.previousBtn = btn6
                }
            } else if ( (yA >= 0 + epsion ) && (yA <= 0.25 - epsion)) { //right
                if (self.previousBtn != btn2) {
                    self.previousBtn?.backgroundColor = UIColor.white
                    btn2.backgroundColor = UIColor.red
                    self.previousBtn = btn2
                }
            } else {
                if (self.previousBtn != btnTT) {
                    self.previousBtn?.backgroundColor = UIColor.white
                    btnTT.backgroundColor = UIColor.red
                    self.previousBtn = btnTT
                }
            }
        }
        
        self.update(value: CGFloat(arr[0]), viewChild: viewValueXa, viewParent: viewXa)
        lblXa.text = "\(arr[0] * 65535)"
        self.update(value: CGFloat(arr[1]), viewChild: viewValueYa, viewParent: viewYa)
        lblYa.text = "\(arr[1] * 65535)"
        self.update(value: CGFloat(arr[2]), viewChild: viewValueZa, viewParent: viewZa)
        lblZa.text = "\(arr[2] * 65535)"
        self.update(value: CGFloat(arr[3]), viewChild: viewValueXg, viewParent: viewXg)
        lblXg.text = "\(arr[3] * 65535)"
        self.update(value: CGFloat(arr[4]), viewChild: viewValueYg, viewParent: viewYg)
        lblYg.text = "\(arr[4] * 65535)"
        self.update(value: CGFloat(arr[5]), viewChild: viewValueZg, viewParent: viewZg)
        lblZg.text = "\(arr[5] * 65535)"
    }
}

extension DisplayViewController : CBCentralManagerDelegate {
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let alertVC = UIAlertController(title: "Warning", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
            self.centralManager?.cancelPeripheralConnection(self.connectingPeripheral!)
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
        let a = String.init(data: characteristic.value!, encoding: String.Encoding.utf8)
        
        if (a?.contains("@"))! {
            self.result = (a?.replacingOccurrences(of: "@", with: "")) ?? ""
        } else {            
            self.result = self.result + a!
            if ( self.result.characters.count != 32) {
                return
            }
            let str = self.result
            self.ArrayResult.removeAll()
            var tmpResult = ""
            var tmp = ""
            for i in 0 ..< str.characters.count {
                let c1 = str[i]
                tmp.append(c1)
                if ( i % 4 == 3) {
                    tmpResult = tmpResult + " " + tmp
                    let a = UInt16.init(tmp, radix: 16)
                    let cg : CGFloat = CGFloat(a!) / CGFloat(65535)
                    
                    if ( i == 27) {
                        let x = Int16(truncatingBitPattern: strtoul(tmp, nil, 16))
                        let temp  =  Float(x) / Float(340) + 36.53
                        self.ArrayResult.append(CGFloat(temp))
                        self.lblResultTemp.text = tmp
                        self.tempDecimal.text = "\(Int(x))"
                        self.lblTemp.text = "\(temp)"
                    } else {
                        self.ArrayResult.append(cg)
                    }
                    tmp = ""
                }
            }
            if (self.ArrayResult.count == 8) {
                self.displayValue(arr: self.ArrayResult)
            }
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
