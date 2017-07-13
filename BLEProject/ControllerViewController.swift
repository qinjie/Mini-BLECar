//
//  ControllerViewController.swift
//  BLEProject
//
//  Created by Anh Tuan on 6/30/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import CoreMotion

class ControllerViewController: UIViewController {
    let UPDATE_INTERVAL = 0.2
    let EPSILON = 0.1
    var motionManager : CMMotionManager!
    @IBOutlet weak var btn0 : UIButton!
    @IBOutlet weak var btn1 : UIButton!
    @IBOutlet weak var btn2 : UIButton!
    @IBOutlet weak var btn3 : UIButton!
    @IBOutlet weak var btn4 : UIButton!
    @IBOutlet weak var btn5 : UIButton!
    @IBOutlet weak var btn6 : UIButton!
    @IBOutlet weak var btn7 : UIButton!
    @IBOutlet weak var btnTT : UIButton!
    
    var previousBtn : UIButton?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeRight
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.motionManager = CMMotionManager()
        self.motionManager.accelerometerUpdateInterval = TimeInterval.init(UPDATE_INTERVAL)
        self.motionManager.deviceMotionUpdateInterval = TimeInterval.init(UPDATE_INTERVAL)
        if ( self.motionManager.isDeviceMotionAvailable == true) {
            self.motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (devicemotion, error) in
                let attitude = devicemotion?.attitude
                if (attitude != nil) {
                    let x = -attitude!.quaternion.y
                    let y = attitude!.quaternion.x
                    let EPSILON = self.EPSILON
                    NSLog("\(x) , \(y)")
                    if (( x < 0.0 - EPSILON) && ( x > -0.5 - EPSILON)) { // Front
                        if (( y < 0.0 - EPSILON) && (y > -0.5 - EPSILON) ) { //Left
                            self.setForBtn(btn: self.btn7)
                        } else if ( ( y > 0.0 + EPSILON) && ( y < 0.5 - EPSILON)) { // RIGHT
                            self.setForBtn(btn: self.btn1)
                        }   else { //front only
                            self.setForBtn(btn: self.btn0)
                        }
                    }
                    else if ( (x > 0.0 + EPSILON) && ( x < 0.5 - EPSILON)) { // BACK
                        if (( y < 0.0 - EPSILON) && (y > -0.5 - EPSILON) ) { //Left
                            self.setForBtn(btn: self.btn5)
                        } else if ( ( y > 0.0 + EPSILON) && ( y < 0.5 - EPSILON)) { // RIGHT
                            self.setForBtn(btn: self.btn3)
                        } else { //Back Only
                            self.setForBtn(btn: self.btn4)
                        }
                    } else {
                        if (( y < 0.0 - EPSILON) && (y > -0.5 - EPSILON) ) { //Left only
                            self.setForBtn(btn: self.btn6)
                        } else if ( ( y > 0.0 + EPSILON) && ( y < 0.5 - EPSILON)) { // RIGHT only
                            self.setForBtn(btn: self.btn2)
                        } else { //Center Only
                            self.setForBtn(btn: self.btnTT)
                        }
                    }
                }
            })
        } else {
            NSLog("Detect is note available")
        }
    }
    
    func setForBtn(btn : UIButton) {
        if btn != self.previousBtn {
            self.previousBtn?.backgroundColor = UIColor.clear
            btn.backgroundColor = UIColor.red
            self.previousBtn = btn
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
