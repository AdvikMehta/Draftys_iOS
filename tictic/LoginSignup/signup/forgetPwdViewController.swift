//
//  forgetPwdViewController.swift
//  Draftys
//
//  Created by Aniruddha on 12/08/21.
//  Copyright © 2021 Junaid Kamoka. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

@available(iOS 12.0, *)
class forgetPwdViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!
    
    @IBAction func backBtnClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var containerHolderCiew: UIView!
    
    
    @IBOutlet weak var emailTf: SkyFloatingLabelTextField!
    
    
    @IBAction func resetPwdClick(_ sender: Any) {
    }
    
    @IBOutlet weak var resetPwdBtnObj: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
      //  self.headerView.isUserInteractionEnabled = true
        
        self.resetPwdBtnObj.backgroundColor = #colorLiteral(red: 0.9528577924, green: 0.9529947639, blue: 0.9528278708, alpha: 1)
        self.resetPwdBtnObj.setTitleColor(#colorLiteral(red: 0.6437677741, green: 0.6631219387, blue: 0.6758852601, alpha: 1), for: .normal)
        self.resetPwdBtnObj.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
        self.emailTf.addTarget(self, action: #selector(emailLoginViewController.textFieldDidChange(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let textCount = emailTf.text?.count
        
        print("change textCount: ",textCount!)
        if textCount! > 3{
            self.resetPwdBtnObj.backgroundColor = #colorLiteral(red: 0.04472430795, green: 0.05244834721, blue: 0.07734320313, alpha: 0.8470588235)
            self.resetPwdBtnObj.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            self.resetPwdBtnObj.isUserInteractionEnabled = true
        }else{
            self.resetPwdBtnObj.backgroundColor = #colorLiteral(red: 0.9528577924, green: 0.9529947639, blue: 0.9528278708, alpha: 1)
            self.resetPwdBtnObj.setTitleColor(#colorLiteral(red: 0.6437677741, green: 0.6631219387, blue: 0.6758852601, alpha: 1), for: .normal)
            self.resetPwdBtnObj.isUserInteractionEnabled = false
        }
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
