//
//  AppDelegate.swift
//  BLEProject
//
//  Created by Anh Tuan on 6/23/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var listData = [DataText]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        // Override point for customization after application launch.
        self.initDataDefault()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vc = ScanningViewController(nibName: "ScanningViewController", bundle: nil)
        
        let nav = UINavigationController(rootViewController: vc)

        self.window?.rootViewController = nav

        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func initDataDefault(){
        let data = UserDefaults.standard.value(forKey: "DataButtonSetting")
        if (data == nil){
            self.initData()
            let a = self.convertDataToJSON()
            UserDefaults.standard.set(a, forKey: "DataButtonSetting")
        }
    }
    
    func initData(){
        self.listData.removeAll()
        self.listData.append(DataText(title: "Connect", pressText: "+CONN", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Disconnect", pressText: "+DISC", releaseText: "", type: 1))
        //left
        
        self.listData.append(DataText(title: "Shake Left", pressText: "-", releaseText: "", type: 1))
        
        self.listData.append(DataText(title: "Shake Right", pressText: "+", releaseText: "", type: 1))
        //rigt
        self.listData.append(DataText(title: "Forward", pressText: "F", releaseText: "S"))
        self.listData.append(DataText(title: "Back", pressText: "B", releaseText: "S"))
        self.listData.append(DataText(title: "Left", pressText: "L", releaseText: "S"))
        self.listData.append(DataText(title: "Right", pressText: "R", releaseText: "S"))
        self.listData.append(DataText(title: "Forward Left", pressText: "G", releaseText: "S"))
        self.listData.append(DataText(title: "Forward Right", pressText: "I", releaseText: "S"))
        self.listData.append(DataText(title: "Back Left", pressText: "H", releaseText: "S"))
        self.listData.append(DataText(title: "Back Right", pressText: "J", releaseText: "S"))
        self.listData.append(DataText(title: "Front Lights On", pressText: "W", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Front Lights Off", pressText: "w", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Back Lights On", pressText: "U", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Back Lights Off", pressText: "u", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Horn On", pressText: "V", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Horn Off", pressText: "v", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Speed 0", pressText: "0", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Speed 10", pressText: "1", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Speed 20", pressText: "2", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Speed 30", pressText: "3", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Speed 40", pressText: "4", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Speed 50", pressText: "5", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Speed 60", pressText: "6", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Speed 70", pressText: "7", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Speed 80", pressText: "8", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Speed 90", pressText: "9", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Speed 100", pressText: "q", releaseText: "", type: 1))
        self.listData.append(DataText(title: "Stop all", pressText: "D", releaseText: "", type: 1))        
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



    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
/*
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if (self.window?.rootViewController?.presentedViewController is ControllButtonViewController){
            let controlBTNVC = self.window?.rootViewController?.presentedViewController
            return .landscape
        } else {
            return .portrait
        }
    }
 */
}

