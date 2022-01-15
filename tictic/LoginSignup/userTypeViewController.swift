//
//  userTypeViewController.swift
//  MusicTok
//
//  Created by Aniruddha on 09/07/21.
//  Copyright © 2021 Junaid Kamoka. All rights reserved.
//

import UIKit
import DropDown

@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
class userTypeViewController: UIViewController {

    
    let dropDown = DropDown()
    
    @IBOutlet weak var nextBtnObj: UIButton!
    
    @available(iOS 13.0, *)
    @IBAction func nextBtnAction(_ sender: Any) {
        
        if(socialEmail == ""){
            
           let savedPhNoStr = UserDefaults.standard.string(forKey: "savedRegPhnNo")
            print("Hitesh",savedPhNoStr)
//Edited By Hitesh 12.11.21
            if(savedPhNoStr!.count > 0){
//            if(savedPhNoStr != nil){
                let vc = self.storyboard?.instantiateViewController(identifier: "nameVC") as! nameViewController
                
                vc.dob = self.dob
                vc.phoneNo = savedPhNoStr!
                vc.user_type  = self.selectUserlabel.text!
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                
                let vc = storyboard?.instantiateViewController(identifier: "phoneNoVC") as! phoneNoViewController
                
                vc.user_type  = self.selectUserlabel.text!
                vc.navFrmStr = "usertype"
                vc.dob_str = dob
               // let vc = self.storyboard?.instantiateViewController(withIdentifier: "dobVC") as! dobViewController
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
        else{
            let vc = self.storyboard?.instantiateViewController(identifier: "nameVC") as! nameViewController
            
            vc.socialEmail = self.socialEmail
            vc.socialID = self.socialID
            vc.authToken  = self.authToken
            vc.firstName = self.firstName
            vc.lastName = self.lastName
            vc.socialUserName = self.socialUserName
            vc.socialSignUpType = self.socialSignUpType
            vc.dob = dob
            vc.user_type = self.selectUserlabel.text!
            
           // vc.navFrmStr = "usertype"
           // let vc = self.storyboard?.instantiateViewController(withIdentifier: "dobVC") as! dobViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var selectUserlabel: UILabel!
    
    
    
    var dob = ""
    var phoneNo = ""
    var username = ""
    
    var email = ""
    var pass = ""
    
    var socialEmail = ""
    var socialID = ""
    var authToken = ""
    var firstName = ""
    var lastName = ""
    var socialUserName = ""
    var socialSignUpType = ""
    
    var fromVC = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("social email " , self.socialEmail)
        
        self.nextBtnObj.backgroundColor = #colorLiteral(red: 0.5750417709, green: 0.5841686726, blue: 0.6059108973, alpha: 1)
        self.nextBtnObj.isUserInteractionEnabled = false
        
        self.selectUserlabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.selectUserlabel.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("tap on label, open dropdown")
        dropDown.dataSource = ["Athlete", "Coach/Scout/Talent Acquisition", "Spectator", "Youth"]//4
        dropDown.anchorView = (self.selectUserlabel!) //5
            dropDown.bottomOffset = CGPoint(x: 0, y: self.selectUserlabel.frame.size.height) //6
            dropDown.show() //7
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              //sender.setTitle(item, for: .normal) //9
                self!.selectUserlabel.text = item
                
                self!.nextBtnObj.backgroundColor = #colorLiteral(red: 0.04472430795, green: 0.05244834721, blue: 0.07734320313, alpha: 0.8470588235)
                self!.nextBtnObj.isUserInteractionEnabled = true
            }
    }
    
    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//
//      return true
//    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        print("shouldChangeCharactersIn")
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
