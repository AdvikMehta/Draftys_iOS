//
//  ResetPwdViewController.swift
//  Draftys
//
//  Created by Aniruddha on 13/08/21.
//  Copyright © 2021 Junaid Kamoka. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ResetPwdViewController: UIViewController {

    
    @IBOutlet weak var navBarView: UIView!
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var oldPwdTf: SkyFloatingLabelTextField!
    @IBOutlet weak var newPwdTf: SkyFloatingLabelTextField!
    @IBOutlet weak var verifyPwdTf: SkyFloatingLabelTextField!
    
    @IBAction func changePwdBtnClick(_ sender: Any) {
    }
    
    @IBOutlet weak var changePwdBtnObj: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
