//
//  UIController.swift
//  BLEProject
//
//  Created by Anh Tuan on 7/11/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import CoreBluetooth
import STPopup
import SwiftyJSON
import CoreMotion
import CoreLocation

class ButtonData2 : NSObject {
    var pressText : String
    var releaseText : String
    init(pressText : String, releaseText : String) {
        self.pressText = pressText
        self.releaseText = releaseText
    }
}

class UIController: UIViewController {
    let UPDATE_INTERVAL = 0.2
    let EPSILON = 0.2
    var motionManager : CMMotionManager!
    
    @IBOutlet weak var slider : DesignableSlider!
    @IBOutlet weak var btnUp : UIButton!
    @IBOutlet weak var btnDown : UIButton!
    @IBOutlet weak var btnLeft : UIButton!
    @IBOutlet weak var btnRight : UIButton!
    
    @IBOutlet weak var Direction4 : UIImageView!
    @IBOutlet weak var Direction5 : UIImageView!
    @IBOutlet weak var Direction6 : UIImageView!
    @IBOutlet weak var Direction7 : UIImageView!
    @IBOutlet weak var Direction8 : UIImageView!
    @IBOutlet weak var Direction9 : UIImageView!
    @IBOutlet weak var Direction10 : UIImageView!
    @IBOutlet weak var Direction11 : UIImageView!
    
    @IBOutlet weak var view1 : UIView!
    @IBOutlet weak var view2 : UIView!
    var listButton = [DataText]()
    var centralManager : CBCentralManager?
    var connectingPeripheral : CBPeripheral?
    var characterictist : CBCharacteristic?
    var service : CBService?
    
    var currentTarget : UIImageView?
    
    var currentState: StatusControl = .Stop
    
    var listData = [ButtonData2]()
    var listDirection = [UIImageView]()
    var currentTouchUp = [Int]()
    var typeControl : TypeControl = .gesture
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.setUp()
        
        self.motionManager = CMMotionManager()
        self.motionManager.accelerometerUpdateInterval = TimeInterval.init(UPDATE_INTERVAL)
        self.motionManager.deviceMotionUpdateInterval = TimeInterval.init(UPDATE_INTERVAL)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.seperateData()
        self.setUpData()
        self.typeControl = TmpValue.typeControl
        self.configure()
    }
    
    func configure(){
        if ( self.typeControl == .gesture){
            self.motionManager.stopDeviceMotionUpdates()
            self.motionManager.stopGyroUpdates()
            self.view1.isHidden = false
            self.view2.isHidden = false
        } else {
            self.view1.isHidden = true
            self.view2.isHidden = true
            self.readAcceleratorData()
        }
    }
    
    func readAcceleratorData(){
        if ( self.motionManager.isDeviceMotionAvailable == true) {
            self.motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (devicemotion, error) in
                let attitude = devicemotion?.attitude
                if (attitude != nil) {
                    let x = -attitude!.quaternion.y
                    let y = attitude!.quaternion.x
                    let EPSILON = self.EPSILON
                    if (( x < 0.0 - EPSILON) && ( x > -0.5 - EPSILON)) { // Front
                        if (( y < 0.0 - EPSILON) && (y > -0.5 - EPSILON) ) { //Left
                            if ( self.currentTarget != nil){
                                self.changeStatus(imgView: self.currentTarget!, status: false)
                            }
                            self.changeStatus(imgView: self.listDirection[7], status: true)
                            self.sendData(str: self.listButton[TypeButton.forward_left.hashValue].pressText)
                        } else if ( ( y > 0.0 + EPSILON) && ( y < 0.5 + EPSILON)) { // RIGHT
                            if ( self.currentTarget != nil){
                                self.changeStatus(imgView: self.currentTarget!, status: false)
                            }
                            self.changeStatus(imgView: self.listDirection[1], status: true)
                            self.sendData(str: self.listButton[TypeButton.forward_right.hashValue].pressText)
                        }   else { //front only
                            if ( self.currentTarget != nil){
                                self.changeStatus(imgView: self.currentTarget!, status: false)
                            }
                            self.changeStatus(imgView: self.listDirection[0], status: true)
                            self.sendData(str: self.listButton[TypeButton.forward.hashValue].pressText)
                        }
                    }
                    else if ( (x > 0.0 + EPSILON) && ( x < 0.5 + EPSILON)) { // BACK
                        NSLog(String.init(format: "%.2f", x))
                        if (( y < 0.0 - EPSILON) && (y > -0.5 - EPSILON) ) { //Left
                            if ( self.currentTarget != nil){
                                self.changeStatus(imgView: self.currentTarget!, status: false)
                            }
                            self.changeStatus(imgView: self.listDirection[5], status: true)
                            self.sendData(str: self.listButton[TypeButton.backLeft.hashValue].pressText)
                        } else if ( ( y > 0.0 + EPSILON) && ( y < 0.5 + EPSILON)) { // RIGHT
                            if ( self.currentTarget != nil){
                                self.changeStatus(imgView: self.currentTarget!, status: false)
                            }
                            self.changeStatus(imgView: self.listDirection[3], status: true)
                            self.sendData(str: self.listButton[TypeButton.backRight.hashValue].pressText)
                        } else { //Back Only
                            if ( self.currentTarget != nil){
                                self.changeStatus(imgView: self.currentTarget!, status: false)
                            }
                            self.changeStatus(imgView: self.listDirection[4], status: true)
                            self.sendData(str: self.listButton[TypeButton.back.hashValue].pressText)
                        }
                    } else {
                        if (( y < 0.0 - EPSILON) && (y > -0.5 - EPSILON) ) { //Left only
                            if ( self.currentTarget != nil){
                                self.changeStatus(imgView: self.currentTarget!, status: false)
                            }
                            self.changeStatus(imgView: self.listDirection[6], status: true)
                            self.sendData(str: self.listButton[TypeButton.left.hashValue].pressText)
                        } else if ( ( y > 0.0 + EPSILON) && ( y < 0.5 + EPSILON)) { // RIGHT only
                            if ( self.currentTarget != nil){
                                self.changeStatus(imgView: self.currentTarget!, status: false)
                            }
                            self.changeStatus(imgView: self.listDirection[2], status: true)
                            self.sendData(str: self.listButton[TypeButton.right.hashValue].pressText)
                        } else { //Center Only
                            if ( self.currentTarget != nil){
                                self.changeStatus(imgView: self.currentTarget!, status: false)
                            }
                            self.sendData(str: self.listButton[TypeButton.stopAll.hashValue].pressText)
                        }
                    }
                }
                /*
                let gravity = devicemotion?.gravity
                if (gravity != nil){
                    let rotation = atan2((gravity?.x) ?? 0.0, (gravity?.y) ?? 0) + Double.pi / 2
                    if (gravity.z > -0.95) {
                        if ((rotation > 0.1) && (rotation < 1)) {
                            let str = self.listButton[TypeButton.rotateLeft.hashValue].pressText
                            self.sendData(str: str)
                        } else if ( (rotation > -1) && (rotation < -0.1)) {
                            let str = self.listButton[TypeButton.rotateRight.hashValue].pressText
                            self.sendData(str: str)
                        }
                    }
                }
 */
            })
            
            self.motionManager.startGyroUpdates(to: OperationQueue.current!) { (data, error) in
                let x = data?.rotationRate.x ?? 0.0
                let y = data?.rotationRate.y ?? 0.0
                let z = data?.rotationRate.z ?? 0.0
                
                let sum = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2))
                
                if ( sum > 8) {
                    if ( z < -5) {
                        //right
                        self.sendData(str: self.listButton[TypeButton.shakeRight.hashValue].pressText)
                    } else if (z > 5) {
                        //Left
                        self.sendData(str: self.listButton[TypeButton.shakeLeft.hashValue].pressText)
                } else {
                        
                    }
                } else {
                    //                if (self.currentTarget != nil){
                    //                    self.changeStatus(imgView: self.currentTarget!, status: false)
                    //                }
                    //                self.sendData(str:self.listData[TypeButton.forward.hashValue].releaseText)
                }
            }
        } else {
            NSLog("Detect is note available")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeRight
    }
    
    @IBAction func pressStart(_ sender : UIButton){
        let text = self.listButton[TypeButton.connect.hashValue].pressText
        self.sendData(str: text)
        self.selectorSlider()
        return
        if (self.currentState == .Stop) {
            self.currentState = .Start
            self.sendData(str: text)
            self.selectorSlider()
        } else {
            self.currentState = .Stop
            self.sendData(str: "+DISC")
        }
    }
    
    //SetUp
    func selectorSlider(){
        NSLog("\(self.slider.value)")
        let a = Int(self.slider.value * 10)
        if ( a < 10) {
            let index = 15
            let text = self.listButton[index + a].pressText
            self.sendData(str: text)
        } else {
            self.sendData(str: self.listButton[TypeButton.speedMax.hashValue].pressText)
        }
    }
    
    func setUpSlider(){
        self.slider.addTarget(self, action: #selector(UIController.selectorSlider), for: UIControlEvents.valueChanged)
    }
    
    func setUp(){
        self.setUpButton()
        self.setUpDirection()
        self.setUpBLE()
        self.setUpSlider()
    }
    
    func setUpBLE(){
        self.centralManager?.delegate = self
        self.connectingPeripheral?.delegate = self
        self.connectingPeripheral?.discoverServices(nil)
    }
    
    func setUpDirection(){
        self.listDirection.append(Direction4)
        self.listDirection.append(Direction5)
        self.listDirection.append(Direction6)
        self.listDirection.append(Direction7)
        self.listDirection.append(Direction8)
        self.listDirection.append(Direction9)
        self.listDirection.append(Direction10)
        self.listDirection.append(Direction11)
        
        var i = 4
        for item in self.listDirection {
            item.tag = i
            i = i + 1
        }
    }
    
    func seperateData(){
        let data = UserDefaults.standard.value(forKey: "DataButtonSetting")
        if (data != nil){
            self.listButton.removeAll()
            let dataContent = data as? String ?? ""
            let json = JSON.init(parseJSON: dataContent)
            for item in json.array! {
                let obj = DataText.init(json: item)
                self.listButton.append(obj)
            }
        }
    }
    
    func setUpData(){
        self.listData.removeAll()
        
//            self.listData.append(ButtonData2(pressText: "F", releaseText: "S"))
//            self.listData.append(ButtonData2(pressText: "I", releaseText: "S"))
//            self.listData.append(ButtonData2(pressText: "R", releaseText: "S"))
//            self.listData.append(ButtonData2(pressText: "J", releaseText: "S"))
//            self.listData.append(ButtonData2(pressText: "B", releaseText: "S"))
//            self.listData.append(ButtonData2(pressText: "H", releaseText: "S"))
//            self.listData.append(ButtonData2(pressText: "L", releaseText: "S"))
//            self.listData.append(ButtonData2(pressText: "G", releaseText: "S"))
//            
            self.listData.append(ButtonData2(pressText: self.listButton[TypeButton.forward.hashValue].pressText, releaseText: self.listButton[TypeButton.forward.hashValue].releaseText))
        
            self.listData.append(ButtonData2(pressText: self.listButton[TypeButton.forward_right.hashValue].pressText, releaseText: self.listButton[TypeButton.forward_right.hashValue].releaseText))
        
            self.listData.append(ButtonData2(pressText: self.listButton[TypeButton.right.hashValue].pressText, releaseText: self.listButton[TypeButton.right.hashValue].releaseText))
        
            self.listData.append(ButtonData2(pressText: self.listButton[TypeButton.backRight.hashValue].pressText, releaseText: self.listButton[TypeButton.backRight.hashValue].releaseText))
        
            self.listData.append(ButtonData2(pressText: self.listButton[TypeButton.back.hashValue].pressText, releaseText: self.listButton[TypeButton.back.hashValue].releaseText))
        
            self.listData.append(ButtonData2(pressText: self.listButton[TypeButton.backLeft.hashValue].pressText, releaseText: self.listButton[TypeButton.backLeft.hashValue].releaseText))
        
            self.listData.append(ButtonData2(pressText: self.listButton[TypeButton.left.hashValue].pressText, releaseText: self.listButton[TypeButton.left.hashValue].releaseText))
        
            self.listData.append(ButtonData2(pressText: self.listButton[TypeButton.forward_left.hashValue].pressText, releaseText: self.listButton[TypeButton.forward_left.hashValue].releaseText))

    }
    
    func setUpButton(){
        self.btnUp.addTarget(self, action: #selector(UIController.eventHold(_:)), for: UIControlEvents.touchDown)
        self.btnDown.addTarget(self, action: #selector(UIController.eventHold(_:)), for: UIControlEvents.touchDown)
        self.btnLeft.addTarget(self, action: #selector(UIController.eventHold(_:)), for: UIControlEvents.touchDown)
        self.btnRight.addTarget(self, action: #selector(UIController.eventHold(_:)), for: UIControlEvents.touchDown)
        
        self.btnUp.addTarget(self, action: #selector(UIController.eventTouchUp(_:)), for: UIControlEvents.touchUpInside)
        self.btnUp.addTarget(self, action: #selector(UIController.eventTouchUp(_:)), for: UIControlEvents.touchUpOutside)
        
        self.btnDown.addTarget(self, action: #selector(UIController.eventTouchUp(_:)), for: UIControlEvents.touchUpInside)
        self.btnDown.addTarget(self, action: #selector(UIController.eventTouchUp(_:)), for: UIControlEvents.touchUpOutside)
        self.btnLeft.addTarget(self, action: #selector(UIController.eventTouchUp(_:)), for: UIControlEvents.touchUpInside)
        self.btnLeft.addTarget(self, action: #selector(UIController.eventTouchUp(_:)), for: UIControlEvents.touchUpOutside)
        self.btnRight.addTarget(self, action: #selector(UIController.eventTouchUp(_:)), for: UIControlEvents.touchUpInside)
        self.btnRight.addTarget(self, action: #selector(UIController.eventTouchUp(_:)), for: UIControlEvents.touchUpOutside)
    }
    
    func changeStatus(imgView : UIImageView, status : Bool){
        if ( status == true){
            imgView.backgroundColor = UIColor.init(rgba: "#d7d7d7")
            self.currentTarget = imgView
        } else {
            imgView.backgroundColor = UIColor.clear
        }
    }
    
    //Event
    
    func eventTouchUp(_ sender : UIButton){
        if ( self.currentTarget != nil){
            self.changeStatus(imgView: self.currentTarget!, status: false)
        }
        let tag = sender.tag
        if ( self.currentTouchUp.count == 1){
            let tag = self.currentTouchUp[0]
            let target = self.listDirection[tag * 2]
            self.sendData(str: self.listData[tag * 2].releaseText)
            
        }
        self.removeValue(value: tag)
        self.solveCurrentTouchUp()
    }
    
    func eventHold(_ sender : UIButton){
        if (currentTouchUp.count == 2) {
            return
        }
        let tag = sender.tag
        if (self.currentTouchUp.count == 1){
            let tagC = self.currentTouchUp[0]
            if (( (tagC - tag) == 2) ||  ((tag - tagC) == -2)) {
                return
            }
        }
        currentTouchUp.append(tag)
        if (self.currentTarget != nil){
            self.changeStatus(imgView: self.currentTarget!, status: false)
        }
        self.solveCurrentTouchUp()
    }
    
    
    //Solve Event
    func solveCurrentTouchUp(){
        if (self.currentTouchUp.count == 0) {
            
        } else
        if ( self.currentTouchUp.count == 1){
            let tag = self.currentTouchUp[0]
            let target = self.listDirection[tag * 2]
            self.changeStatus(imgView: target, status: true)
            self.sendData(str: self.listData[tag * 2].pressText)
        } else if (self.currentTouchUp.count == 2) {
            let tag1 = self.currentTouchUp[0]
            let tag2 = self.currentTouchUp[1]
            if ( (tag1 * tag2 == 0 ) && ( tag2 + tag1 == 3)) {
                let target = self.listDirection[7]
                self.changeStatus(imgView: target, status: true)
                self.sendData(str: self.listData[7].pressText)
            } else {
                let target = self.listDirection[tag1 + tag2]
                self.changeStatus(imgView: target, status: true)
                self.sendData(str: self.listData[tag1 + tag2].pressText)
            }
            
        }
    }
    
    func removeValue(value : Int){
        var pos = -1
        for i in 0 ..< self.currentTouchUp.count {
            let a = self.currentTouchUp[i]
            if ( a == value){
                pos = i
                break
            }
        }
        if (pos != -1){
            self.currentTouchUp.remove(at: pos)
        }
    }

    @IBAction func close(){
        self.dismiss(animated: true) { 
            self.sendData(str: self.listButton[TypeButton.stopAll.hashValue].pressText)
            self.sendData(str: self.listButton[TypeButton.disconnect.hashValue].pressText)
        }
    }
    
    func sendData(str : String) {
        
        let b = str
        
        let data = b.data(using: String.Encoding.utf8)
        if ((data != nil) && (self.characterictist != nil)){
            self.connectingPeripheral?.writeValue(data!, for: self.characterictist!, type: CBCharacteristicWriteType.withResponse)
        }
    }
    
    @IBAction func disConnectPress(_ sender : UIButton){
        self.sendData(str: self.listButton[TypeButton.disconnect.hashValue].pressText)
    }
    
    @IBAction func frontCarTouchUp(_ sender : UIButton){
        sender.isSelected = !sender.isSelected
        if (sender.isSelected == true){
            self.sendData(str: self.listButton[TypeButton.frontLightOn.hashValue].pressText)
        } else {
            self.sendData(str: self.listButton[TypeButton.frontLightOff.hashValue].pressText)
        }
    }
    
    @IBAction func backCarTouchUp(_ sender : UIButton){
        sender.isSelected = !sender.isSelected
        if (sender.isSelected == true){
            self.sendData(str: self.listButton[TypeButton.backLightOn.hashValue].pressText)
        } else {
            self.sendData(str: self.listButton[TypeButton.backLightOff.hashValue].pressText)
        }
    }
    
    @IBAction func speakerCarTouchUp(_ sender : UIButton){
        sender.isSelected = !sender.isSelected
        if (sender.isSelected == true){
            self.sendData(str: self.listButton[TypeButton.hornOn.hashValue].pressText)
        } else {
            self.sendData(str: self.listButton[TypeButton.hornOff.hashValue].pressText)
        }
    }
    
    @IBAction func AttentionCarTouchUp(_ sender : UIButton){
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func settingCarTouchUp(_ sender : UIButton){
        self.sendData(str: self.listButton[TypeButton.stopAll.hashValue].releaseText)
        self.motionManager.stopDeviceMotionUpdates()
        self.motionManager.stopGyroUpdates()
        let vc = PopUpSetUpViewController(nibName: "PopUpSetUpViewController", bundle: nil)
        let stpopup = STPopupController(rootViewController: vc)
        stpopup.present(in: self)
    }
    
    func stopDevicemotion(){
        self.motionManager.stopGyroUpdates()
        self.motionManager.stopDeviceMotionUpdates()
        self.motionManager.stopMagnetometerUpdates()
        self.motionManager.stopAccelerometerUpdates()
    }
}

extension UIController : CBCentralManagerDelegate {
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if (error != nil) {
            let alertVC = UIAlertController(title: "Warning", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
                self.stopDevicemotion()
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
            
            
            let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
                self.centralManager?.cancelPeripheralConnection(self.connectingPeripheral!)
                self.stopDevicemotion()
            }
            alertVC.addAction(alertAction)
            self.show(alertVC, sender: nil)
            
            self.show(alertVC, sender: nil)
        }
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if (error != nil) {
            let alertVC = UIAlertController(title: "Warning", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
            
            let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.stopDevicemotion()
                self.dismiss(animated: true, completion: nil)
                self.centralManager?.cancelPeripheralConnection(self.connectingPeripheral!)
            }
            alertVC.addAction(alertAction)
            self.show(alertVC, sender: nil)
        }

    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
    }
    
}

extension UIController : CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            NSLog("Services: \(service.uuid.uuidString)")
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
    }
}



