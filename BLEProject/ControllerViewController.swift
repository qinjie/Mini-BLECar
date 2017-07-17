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
    let UPDATE_INTERVAL = 1
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
    
    var currentTransfrom : CGAffineTransform?
    
    @IBOutlet weak var view1 : UIView!
    
    var previousBtn : UIButton?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeRight
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.motionManager = CMMotionManager()
        
        self.motionManager.startDeviceMotionUpdates()
        self.motionManager.startAccelerometerUpdates()
        self.motionManager.gyroUpdateInterval = TimeInterval(UPDATE_INTERVAL)
        
        self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            
            let x = data?.acceleration.x
            let y = data?.acceleration.x
            let z = data?.acceleration.x
            
            
            let a = String.init(format: "x:  %.2f  y:  %2.f   z: %.2f", x!,y!,z!)
            
        }
        
        
/*
        self.motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error) in
            if let gravity = data?.gravity {
                let rotation = atan2(-gravity.x, -gravity.y) - Double.pi / 2
                    NSLog("Rotation   \(rotation)")
                    if ((rotation > 0.1) && (rotation < 1)) {
                        NSLog("Left")
                    } else if ( (rotation > -1) && (rotation < -0.1)) {
                        NSLog("Right")
                    }
            }
        }
 */
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

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 0.01, completionDelegate: AnyObject? = nil, toValue: CGFloat, current: CGAffineTransform) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = self.transform
        rotateAnimation.toValue = current.rotated(by: toValue)
        
        
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as? CAAnimationDelegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
