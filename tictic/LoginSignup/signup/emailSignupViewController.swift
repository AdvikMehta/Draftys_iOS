//
//  emailSignupViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 15/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class emailSignupViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    var email = ""
    var user_type = ""
    var dob_str = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnNext.backgroundColor = #colorLiteral(red: 0.9528577924, green: 0.9529947639, blue: 0.9528278708, alpha: 1)
        btnNext.setTitleColor(#colorLiteral(red: 0.6437677741, green: 0.6631219387, blue: 0.6758852601, alpha: 1), for: .normal)
        btnNext.isUserInteractionEnabled = false
        emailTxtField.tintColor = #colorLiteral(red: 0.1663755774, green: 0.2092176974, blue: 0.2607190311, alpha: 1)
        emailTxtField.addTarget(self, action: #selector(nameViewController.textFieldDidChange(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let textCount = emailTxtField.text?.count
        
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
        
        email = emailTxtField.text!
        
        if AppUtility?.isEmail(email) == false {
            showToast(message: "Invalid Email", font: .systemFont(ofSize: 12))
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "passwordVC") as! passwordViewController
            vc.email = email
            vc.user_type = UserDefaults.standard.string(forKey: "signup_user_type")!
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
    //    MARK:- Terms & privacy
    @IBAction func privacy(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "termsCondVC") as! termsCondViewController
        vc.privacyDoc = true
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        //        guard let url = URL(string: "https://termsfeed.com/privacy-policy/9a03bedc2f642faf5b4a91c68643b1ae") else { return }
        //        UIApplication.shared.open(url)
    }
    
    @IBAction func terms(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "termsCondVC") as! termsCondViewController
        vc.privacyDoc = false
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        
        //        guard let url = URL(string: "https://termsfeed.com/terms-conditions/72b8fed5b38e082d48c9889e4d1276a9") else { return }
        //        UIApplication.shared.open(url)
        
    }
}
