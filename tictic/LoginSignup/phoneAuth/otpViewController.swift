//
//  otpViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 12/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import Firebase

@available(iOS 12.0, *)
class otpViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var otpTextField: OneTimeCodeTextField!
    @IBOutlet weak var sendOnNoLbl: UILabel!
    

    @IBOutlet weak var btnNext: UIButton!
    
    var phoneNo = ""
    var otp = ""
    var user_type = ""
    var dob_str = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendOnNoLbl.text = "Your code was sent  to  \(phoneNo)"
        otpSetup()
        otpTextField.addTarget(self, action: #selector(otpViewController.textFieldDidChange(_:)), for: .editingChanged)
        btnNext.backgroundColor = #colorLiteral(red: 0.9528577924, green: 0.9529947639, blue: 0.9528278708, alpha: 1)
        btnNext.setTitleColor(#colorLiteral(red: 0.6437677741, green: 0.6631219387, blue: 0.6758852601, alpha: 1), for: .normal)
        btnNext.isUserInteractionEnabled = false
        
        print("phoneNo " , phoneNo)
        self.getOtpFromFirebase()
        // Do any additional setup after loading the view.
    }
    
    func getOtpFromFirebase(){
        
        PhoneAuthProvider.provider()
          .verifyPhoneNumber(phoneNo, uiDelegate: nil) { verificationID, error in
              if let error = error {
                print("error " , error.localizedDescription)
               // self.showMessagePrompt(error.localizedDescription)
                return
              }
            
            print("verificationID " , verificationID as Any)
              // Sign in using the verificationID and the code sent to the user
              // ...
          }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let textCount = otpTextField.text?.count
        
        print("change textCount: ",textCount!)
        if textCount! > 3{
            btnNext.backgroundColor = #colorLiteral(red: 0.04472430795, green: 0.05244834721, blue: 0.07734320313, alpha: 0.8470588235)
            btnNext.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            btnNext.isUserInteractionEnabled = true
        }else{
            btnNext.backgroundColor = #colorLiteral(red: 0.9528577924, green: 0.9529947639, blue: 0.9528278708, alpha: 1)
            btnNext.setTitleColor(#colorLiteral(red: 0.6437677741, green: 0.6631219387, blue: 0.6758852601, alpha: 1), for: .normal)
            btnNext.isUserInteractionEnabled = false
        }
    }
    
    func otpSetup(){
        otpTextField.defaultCharacter = "_"
        otpTextField.textColor = .gray
        
        otpTextField.configure()
        otpTextField.didEnterLastDigit = { [weak self] code in
            print("otp code: ",self!.otpTextField.text)
            
            self?.otp = self!.otpTextField.text!
        }
        
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
        if #available(iOS 13.0, *) {
            verifyOTPfunc()
        } else {
            // Fallback on earlier versions
        }
    }
    @available(iOS 13.0, *)
    @IBAction func btnResenOTP(_ sender: Any) {
     //   verifyPhoneFunc()
        self.getOtpFromFirebase()
    }
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @available(iOS 13.0, *)
    @available(iOS 13.0, *)
    func verifyOTPfunc(){
        let phoneNoNew = phoneNo.trimmingCharacters(in: .whitespaces)
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.verifyOTP(phone: phoneNoNew, verify: "1", code: otp) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    AppUtility?.stopLoader(view: self.view)
//                    self.alertModule(title: NSLocalizedString("alert_app_name", comment: ""), msg: response?.value(forKey: "msg") as! String )
                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    self.registerPhoneCeck()
                    
                }else{
                    AppUtility?.stopLoader(view: self.view)
                   // self.alertModule(title: NSLocalizedString("alert_app_name", comment: ""), msg: response?.value(forKey: "msg") as! String)
                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))

                }
            }else{
                AppUtility?.stopLoader(view: self.view)
                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12.0))
            }
        }
    }
    
    @available(iOS 13.0, *)
    func verifyPhoneFunc(){
        let phoneNoNew = phoneNo.trimmingCharacters(in: .whitespaces)
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.verifyPhoneNo(phone: phoneNoNew, verify: "0") { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    AppUtility?.stopLoader(view: self.view)
                    self.alertModule(title: NSLocalizedString("alert_app_name", comment: ""), msg: response?.value(forKey: "msg") as! String )
                    self.otpTextField.text?.removeAll()
                    
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    self.alertModule(title: NSLocalizedString("alert_app_name", comment: ""), msg: response?.value(forKey: "msg") as! String)
                 
                }
            }else{
                AppUtility?.stopLoader(view: self.view)
                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12.0))
            }
        }
    }
    @available(iOS 13.0, *)
    func registerPhoneCeck(){
        
        let phoneNoNew = phoneNo.trimmingCharacters(in: .whitespaces)
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.registerPhoneCheck(phone: phoneNoNew , user_type:user_type) { (isSuccess, response) in
            if isSuccess{
                print("inside is Success")
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    AppUtility?.stopLoader(view: self.view)
                    
//                    self.alertModule(title: NSLocalizedString("alert_app_name", comment: ""), msg: response?.value(forKey: "msg") as! String )
                    
                    self.showToast(message: "Already Registered", font: .systemFont(ofSize: 12))
                    
                    
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userObj = userObjMsg.value(forKey: "User") as! NSDictionary
                    print("user obj: ",userObj)
                    //if user already registered code it
                    let user = User()
                    user.id = userObj.value(forKey: "id") as? String
                    user.active = userObj.value(forKey: "active") as? String
                    user.city = userObj.value(forKey: "city") as? String
                    
                    UserDefaults.standard.set(userObj.value(forKey: "id") as? String, forKey: "userID")
                    UserDefaults.standard.set(userObj.value(forKey: "auth_token") as? String, forKey: "authToken")

                    user.country = userObj.value(forKey: "country") as? String
                    user.created = userObj.value(forKey: "created") as? String
                    user.device = userObj.value(forKey: "device") as? String
                    user.dob = userObj.value(forKey: "dob") as? String

                    user.email = userObj.value(forKey: "email") as? String
                    user.fb_id = userObj.value(forKey: "fb_id") as? String

                    user.first_name = userObj.value(forKey: "first_name") as? String
                    user.gender = userObj.value(forKey: "gender") as? String
                    user.last_name = userObj.value(forKey: "last_name") as? String
                    user.ip = userObj.value(forKey: "ip") as? String
                    user.lat = userObj.value(forKey: "lat") as? String
                    user.long = userObj.value(forKey: "long") as? String
                    user.online = userObj.value(forKey: "online") as? String
                    user.password = userObj.value(forKey: "password") as? String
                    user.phone = userObj.value(forKey: "phone") as? String

                    user.profile_pic = userObj.value(forKey: "profile_pic") as? String
                    user.role = userObj.value(forKey: "role") as? String
                    user.social = userObj.value(forKey: "social") as? String
                    user.social_id = userObj.value(forKey: "social_id") as? String
                    user.username = userObj.value(forKey: "username") as? String
                    user.verified = userObj.value(forKey: "verified") as? String
                    user.version = userObj.value(forKey: "version") as? String
                    user.website = userObj.value(forKey: "website") as? String

                    user.comments = userObj.value(forKey: "comments") as? String
                    user.direct_messages = userObj.value(forKey: "direct_messages") as? String

                    user.likes = userObj.value(forKey: "likes") as? String
                    user.mentions = userObj.value(forKey: "mentions") as? String
                    user.new_followers = userObj.value(forKey: "new_followers") as? String
                    user.video_updates = userObj.value(forKey: "video_updates") as? String
                    user.direct_message = userObj.value(forKey: "direct_message") as? String

                    user.duet = userObj.value(forKey: "duet") as? String
                    user.liked_videos = userObj.value(forKey: "liked_videos") as? String
                    user.video_comment = userObj.value(forKey: "video_comment") as? String
                    user.videos_download = userObj.value(forKey: "videos_download") as? String
                    
                    if User.saveUserToArchive(user: [user]){
//                        self.navigationController?.popToRootViewController(animated: true)
//                        NotificationCenter.default.post(name: Notification.Name("dismissVCnoti"), object: nil)
                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                    self.otpTextField.text?.removeAll()
                    
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    if(self.user_type == ""){
                        
                        /*vc.dob = self.dob_str
                        vc.phoneNo = self.phoneNo
                        vc.user_type  = self.user_type*/
                        
                        UserDefaults.standard.set(self.phoneNo, forKey: "savedRegPhnNo")
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "dobVC") as! dobViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }
                    else{
                        
                        UserDefaults.standard.set("", forKey: "savedRegPhnNo")
                        
                        
                        let vc = self.storyboard?.instantiateViewController(identifier: "nameVC") as! nameViewController
                        
                        vc.dob = self.dob_str
                        vc.phoneNo = self.phoneNo
                        vc.user_type  = self.user_type
                       
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                    //if user not registered
                    
                    
                }
            }else{
                AppUtility?.stopLoader(view: self.view)
                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12.0))
            }
        }
    }

    
    //    MARK:- ALERT MODULE
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
}
