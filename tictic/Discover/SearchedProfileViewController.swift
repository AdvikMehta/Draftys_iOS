//
//  SearchedProfileViewController.swift
//  Draftys
//
//  Created by Aniruddha on 23/07/21.
//  Copyright © 2021 Junaid Kamoka. All rights reserved.
//

import UIKit
import SDWebImage

class SearchedProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var profileDataArray:NSArray! = []
    
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBOutlet weak var profileListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("profileDataArray " , profileDataArray as Any)
        
        self.profileListTableView.delegate = self
        self.profileListTableView.dataSource = self
        self.profileListTableView.separatorColor = UIColor.clear
        
        
        // Do any additional setup after loading the view.
    }//
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profileDataArray.count
    }
       
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchedprofileListTableViewCell", for: indexPath)
                                  as! searchedprofileListTableViewCell
       // print("cellForRowAt")
          
        
        let tempDataDic : NSDictionary = self.profileDataArray[indexPath.row] as! NSDictionary
        
        let userDataDic = tempDataDic["user"] as! NSDictionary
        
        
       
        
        cell.profileImageView.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: userDataDic["profile_pic"] as! String ))!), placeholderImage: UIImage(named:"noUserImg"))
        
        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width/2
        cell.profileImageView.clipsToBounds = true
        
        cell.profileUserNameLbl.text = (userDataDic["username"] as! String)
        cell.profileNameLbl.text = (userDataDic["first_name"] as! String) + " " + (userDataDic["last_name"] as! String)
        
        cell.selectionStyle = searchedprofileListTableViewCell.SelectionStyle.none
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let userID = UserDefaults.standard.string(forKey: "userID")
        
        if userID == nil || userID == ""{
            self.loginScreenAppear()
        }
        else{
            
            let tempDataDic : NSDictionary = self.profileDataArray[indexPath.row] as! NSDictionary
            
            let userDataDic = tempDataDic["user"] as! NSDictionary
            //isOtherUserVisting
            print("ID Selected " , userDataDic["id"] as! String)
            let vc = storyboard?.instantiateViewController(withIdentifier: "newProfileVC") as!  newProfileViewController
            vc.isOtherUserVisting = true
            vc.hidesBottomBarWhenPushed = true
            vc.otherUserID = userDataDic["id"] as! String
            navigationController?.pushViewController(vc, animated: true)
            
        }
       
    }
    
    
    func loginScreenAppear(){
        let navController = UINavigationController.init(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "newLoginVC"))
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .overFullScreen
        
        self.present(navController, animated: true, completion: nil)
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
