//
//  splashViewController.swift
//  MusicTok
//
//  Created by Junaid  Kamoka on 04/03/2021.
//  Copyright © 2021 Junaid Kamoka. All rights reserved.
//

import UIKit

class splashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility?.addDeviceData()
        settingUDID()
        // Do any additional setup after loading the view.
    }
    

    func settingUDID(){
        let uid = UIDevice.current.identifierForVendor!.uuidString
        ApiHandler.sharedInstance.registerDevice(key: uid) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    let msg = response?.value(forKey: "msg") as! NSDictionary
                    let device = msg.value(forKey: "Device") as! NSDictionary
                    let key = device.value(forKey: "key") as! String
                    let deviceID = device.value(forKey: "id") as! String
                    print("deviceKey: ",key)
                    
                    UserDefaults.standard.set(key, forKey: "deviceKey")
                    UserDefaults.standard.set(deviceID, forKey: "deviceID")
                    
                    print("response@200: ",response!)
                    
//                    self.getDataForFeeds()
                    
                    let story = UIStoryboard(name: "Main", bundle: nil)
                    let vc = story.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
                    let nav = UINavigationController(rootViewController: vc)
                    nav.navigationBar.isHidden = true
//                    self.window?.rootViewController = nav
                    self.view.window?.rootViewController = nav
                }else{
                    print("response not 200: ",response!)
                    
                    ApiHandler.sharedInstance.showDeviceDetails(key: uid) { (isSuccess, response) in
                        if isSuccess{
                            if response?.value(forKey: "code") as! NSNumber == 200 {
                                
                                let msg = response?.value(forKey: "msg") as! NSDictionary
                                let device = msg.value(forKey: "Device") as! NSDictionary
                                let key = device.value(forKey: "key") as! String
                                let deviceID = device.value(forKey: "id") as! String
                                print("device id: ",deviceID)
                                
                                UserDefaults.standard.set(key, forKey: "deviceKey")
                                UserDefaults.standard.set(deviceID, forKey: "deviceID")
                                
//                                self.getDataForFeeds()
                                
                                let story = UIStoryboard(name: "Main", bundle: nil)
                                let vc = story.instantiateViewController(withIdentifier: "TabbarViewController") as! TabbarViewController
                                let nav = UINavigationController(rootViewController: vc)
                                nav.navigationBar.isHidden = true
            //                    self.window?.rootViewController = nav
                                self.view.window?.rootViewController = nav
                                
                                print("deviceKey: ", key)
                                print("response@200: ",response!)
                            }else{
                                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12.0))
                            }
                        }
                    }
                    
                }
            }else{
                print("Something went wrong in API registerDevice: ",response!)
            }
        }
    }

}
