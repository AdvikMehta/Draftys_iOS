//
//  passwordViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 15/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class passwordViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    var email = ""
    var pass = ""
    var user_type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.backgroundColor = #colorLiteral(red: 0.9528577924, green: 0.9529947639, blue: 0.9528278708, alpha: 1)
        btnNext.setTitleColor(#colorLiteral(red: 0.6437677741, green: 0.6631219387, blue: 0.6758852601, alpha: 1), for: .normal)
        btnNext.isUserInteractionEnabled = false
        passTxtField.isSecureTextEntry = true
        passTxtField.tintColor = #colorLiteral(red: 0.1663755774, green: 0.2092176974, blue: 0.2607190311, alpha: 1)
        passTxtField.addTarget(self, action: #selector(nameViewController.textFieldDidChange(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
        print("user_type val " , user_type)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let textCount = passTxtField.text?.count
        
        print("change textCount: ",textCount!)
        if textCount! > 3{
            btnNext.backgroundColor = #colorLiteral(red: 0.1663755774, green: 0.2092176974, blue: 0.2607190311, alpha: 1)
            btnNext.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            btnNext.isUserInteractionEnabled = true
        }else{
            btnNext.backgroundColor = #colorLiteral(red: 0.9528577924, green: 0.9529947639, blue: 0.9528278708, alpha: 1)
            btnNext.setTitleColor(#colorLiteral(red: 0.6437677741, green: 0.6631219387, blue: 0.6758852601, alpha: 1), for: .normal)
            btnNext.isUserInteractionEnabled = false
        }
    }
    
    
    @IBAction func btnNextFunc(_ sender: Any) {
        
        pass = passTxtField.text!
        
        print("email \(email) pass: \(pass)")
        if validatePassword(pass) == true{
//            let vc = storyboard?.instantiateViewController(withIdentifier: "dobVC") as! dobViewController
//
//            vc.email = email
//            vc.pass = pass
//
//            self.navigationController?.pushViewController(vc, animated: true)
            //
            
            let vc = self.storyboard?.instantiateViewController(identifier: "nameVC") as! nameViewController
            
            vc.dob = "1990-01-01"
            vc.user_type  = self.user_type
            vc.email = email
            vc.pass = pass
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //    MARK:- password regex
    func validatePassword(_ password: String) -> Bool {
        //At least 8 characters
        if password.count < 8 {
            self.showToast(message: "Minimum 8 Character", font: .systemFont(ofSize: 12))
            return false
        }
        
        //At least one digit
        if password.range(of: #"\d+"#, options: .regularExpression) == nil {
            self.showToast(message: "Atleast One Digit", font: .systemFont(ofSize: 12))
            return false
        }
        
        //At least one letter
        if password.range(of: #"\p{Alphabetic}+"#, options: .regularExpression) == nil {
            
            self.showToast(message: "Alleast one Letter", font: .systemFont(ofSize: 12))
            return false
        }
        
        //No whitespace charcters
        if password.range(of: #"\s+"#, options: .regularExpression) != nil {
            self.showToast(message: "Remove Space", font: .systemFont(ofSize: 12))
            
            return false
        }
        
        return true
    }
}
