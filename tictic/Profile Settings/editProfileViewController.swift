//
//  editProfileViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 20/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import SDWebImage
import DropDown

class editProfileViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var profileTypeLbl: UILabel!
    
    
    @IBOutlet weak var masterScrollView: UIScrollView!
    
    @IBOutlet weak var allViewHolderView: UIView!
    
    @IBOutlet weak var sportsHolderMasterView: UIView!
    
    @IBOutlet weak var sportsHdrView: UIView!
    
    @IBOutlet weak var sportsContentView: UIView!
    
    @IBOutlet weak var sportsContentLbl: UILabel!
    
    @IBOutlet weak var positionHdrView: UIView!
    
    @IBOutlet weak var positionContentView: UIView!
    
    @IBOutlet weak var positionContentLbl: UILabel!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var websiteView: UIView!
    @IBOutlet weak var bioView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editPhotoIcon: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var nameHolderView: UIView!
    @IBOutlet weak var nameTF: CustomTextField!
    @IBOutlet weak var second_nameTF: CustomTextField!
    @IBOutlet weak var first_nameTF: CustomTextField!
    
    
    @IBOutlet weak var selectedbtn: UIButton!
    @IBOutlet weak var unselectedbtn: UIButton!
    
    @IBOutlet weak var websiteTF: CustomTextField!
    @IBOutlet weak var bioTF: CustomTextField!
    
    @IBOutlet weak var bioTxtView: UITextView!
    
    @IBOutlet weak var cityHolderView: UIView!

    @IBOutlet weak var cityTF: CustomTextField!
    

    @IBOutlet weak var stateHolderView: UIView!
        
    @IBOutlet weak var stateTF: CustomTextField!
    
    @IBOutlet weak var heightDisplayHolderView: UIView!
   
    
    @IBOutlet weak var htInFeetHdrLbl: UILabel!
    @IBOutlet weak var heightInFeetTF: UITextField!

    @IBOutlet weak var htInInchHdrLbl: UILabel!
    
    
    @IBOutlet weak var heightInInchTF: UITextField!
    
    
    
    
    @IBOutlet weak var weightHolderView: UIView!
    
    @IBOutlet weak var weightTf: CustomTextField!
    
    
    @IBOutlet weak var achivementHdrView: UIView!
    
    @IBOutlet weak var achivementTf: CustomTextField!
    
    @IBOutlet weak var committedHdrView: UIView!
    
    @IBOutlet weak var committedRadioView: UIView!
    
    @IBOutlet weak var gpaTf: UITextField!
    
    @IBOutlet weak var graduatingYrTf: UITextField!
    
    
    @IBOutlet weak var gpaYearHolderView: UIView!
    
    
    @IBAction func commitedYesClick(_ sender: Any) {
        
        self.committedYesBtnObj.setImage(UIImage(named: "selected"), for: .normal)
        self.committedNoBtnObj.setImage(UIImage(named: "unselected"), for: .normal)
        
        isCommited = true
    }
    
    @IBAction func committedNoClick(_ sender: Any) {
        
        self.committedYesBtnObj.setImage(UIImage(named: "unselected"), for: .normal)
        self.committedNoBtnObj.setImage(UIImage(named: "selected"), for: .normal)
        
        isCommited = false
    }
    @IBOutlet weak var committedNoBtnObj: UIButton!
    @IBOutlet weak var committedYesBtnObj: UIButton!
    
    var userData = [userMVC]()
    
    var profilePicData = ""
    var isMale = true
    var isCommited = true
    var isAthelete = false
    
    var isCoach = false
    
    
    var sportsNameArray : NSMutableArray = []
    var sportsIdArray : NSMutableArray = []
    let sportsDropDown = DropDown()
    var selectedSportsId = ""
    
    var initSliderHolderRect :CGRect = CGRect.init()
    
    let positionDropDown = DropDown()
    var selectedPosId = ""
    var posnameArray : NSMutableArray = []
    var posIdArray : NSMutableArray = []
    var minTextViewHeight = 28.0
    var maxTextViewHeight = HUGE
    
    var gpavalArray = ["2.0","2.2" , "2.4","2.6","2.8" , "3.0","3.2","3.4" , "3.6","3.8","4.0"]
    
    var gradYrValArray = ["1960","1961","1962","1963","1964","1965","1966","1967","1968","1969","1970","1971","1972","1973","1974","1975","1976","1977","1978","1979","1980","1981","1982","1983","1984","1985","1986","1987","1988","1989","1990","1991","1992","1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023","2024","2025","2026","2027","2028","2029","2030","2031"]
    
    var heightValArray = ["3","4","5","6","7","8"]
    
    var heightIncValArray = ["0","1","2","3","4","5","6","7","8","9","10","11"]
    
    let dropDownHtFt = DropDown()
    let dropDownHtInch = DropDown()
    let dropDownGpa = DropDown()
    let dropDownGradYear = DropDown()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSetup()
        self.bioTxtView.delegate = self
        
        
        self.bioTxtView.showsHorizontalScrollIndicator = false
        self.bioTxtView.showsVerticalScrollIndicator = false
        self.bioTxtView.backgroundColor = UIColor.clear
       // [self.bioTxtView setShowsHorizontalScrollIndicator:NO];
        //[self.bioTxtView setShowsVerticalScrollIndicator:NO];
        
        self.bioTF.alpha = 0.0
        
        
        self.sportsContentLbl.layer.cornerRadius = 4.0
        self.sportsContentLbl.clipsToBounds = true
        
        self.positionContentLbl.layer.cornerRadius = 4.0
        self.positionContentLbl.clipsToBounds = true
        
        self.heightInFeetTF.delegate = self
        self.heightInInchTF.delegate = self
        self.gpaTf.delegate = self
        self.graduatingYrTf.delegate = self
        
        
        self.initSliderHolderRect = self.allViewHolderView.frame
        
        self.masterScrollView.contentSize.height = self.allViewHolderView.frame.origin.y + self.allViewHolderView.frame.size.height + 50
        
        let bottomBorder = CALayer()
        bottomBorder.borderColor = #colorLiteral(red: 0.8352941176, green: 0.8352941176, blue: 0.8352941176, alpha: 1);
        bottomBorder.borderWidth = 0.5;
        bottomBorder.frame = CGRect(x: 0, y: topView.frame.height, width: view.frame.width, height: 1)
        topView.layer.addSublayer(bottomBorder)
        
        
        let Border = CALayer()
        Border.borderColor = #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1);
        Border.borderWidth = 0.5;
        Border.frame = CGRect(x: 0, y: genderView.frame.height, width: genderView.frame.width, height: 1)
        genderView.layer.addSublayer(Border)
        
        
        let bo = CALayer()
        bo.borderColor = #colorLiteral(red: 0.8352941176, green: 0.8352941176, blue: 0.8352941176, alpha: 1);
        bo.borderWidth = 0.5;
        bo.frame = CGRect(x: 0, y: websiteView.frame.height, width: websiteView.frame.width, height: 1)
        websiteView.layer.addSublayer(bo)
        
        
        let bottom = CALayer()
        bottom.borderColor = #colorLiteral(red: 0.8352941176, green: 0.8352941176, blue: 0.8352941176, alpha: 1);
        bottom.borderWidth = 0.5;
        bottom.frame = CGRect(x: 0, y: bioView.frame.height, width: bioView.frame.width, height: 1)
        bioView.layer.addSublayer(bottom)
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImage(tapGestureRecognizer:)))
        editPhotoIcon.isUserInteractionEnabled = true
        editPhotoIcon.addGestureRecognizer(tapGestureRecognizer)
       
      
        self.applyLeftPadding(tf: self.heightInFeetTF)
        self.applyLeftPadding(tf: self.heightInInchTF)
        
        self.applyLeftPadding(tf: self.gpaTf)
        self.applyLeftPadding(tf: self.graduatingYrTf)
        
        
        self.heightInFeetTF.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnHeightFeeet(_:)))
        self.heightInFeetTF.addGestureRecognizer(tap)
        
        
        self.heightInInchTF.isUserInteractionEnabled = true
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnHeightIncf(_:)))
        self.heightInInchTF.addGestureRecognizer(tap1)
        
        self.gpaTf.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnGpa(_:)))
        self.gpaTf.addGestureRecognizer(tap2)
        
        self.graduatingYrTf.isUserInteractionEnabled = true
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnGradYr(_:)))
        self.graduatingYrTf.addGestureRecognizer(tap3)
        
        
        let tapIOnSportsView = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnSports(_:)))
        self.sportsContentView.addGestureRecognizer(tapIOnSportsView)
        
        
        let tapIOnPositionView = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnPosition(_:)))
        self.positionContentView.addGestureRecognizer(tapIOnPositionView)
        
        self.fetchSpotsList()
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if(textView.text.count > 0){
            if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
        }
        
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text.count == 0){
            self.bioTxtView.text = "Bio"
            self.bioTxtView.textColor = UIColor.lightGray
        }
    }
    
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
          
        self.adjustFrames(textView: textView)
        return true
    }


    func adjustFrames(textView : UITextView)
    {
        var txtFrame : CGRect = textView.frame;
        txtFrame.size.height = textView.contentSize.height;
        textView.frame = txtFrame;
        
        self.cityHolderView.frame = CGRect(x: self.cityHolderView.frame.origin.x, y: txtFrame.origin.y + txtFrame.size.height + 25, width: self.cityHolderView.frame.size.width, height: self.cityHolderView.frame.size.height)
        
        
        self.stateHolderView.frame = CGRect(x: self.stateHolderView.frame.origin.x, y: self.cityHolderView.frame.origin.y + self.cityHolderView.frame.size.height + 25, width: self.stateHolderView.frame.size.width, height: self.stateHolderView.frame.size.height)
        
        
        
        self.achivementHdrView.frame = CGRect(x: self.achivementHdrView.frame.origin.x, y: self.stateHolderView.frame.origin.y + self.stateHolderView.frame.size.height + 25, width: self.achivementHdrView.frame.size.width, height: self.achivementHdrView.frame.size.height)
        
        
        self.achivementTf.frame = CGRect(x: self.achivementTf.frame.origin.x, y: self.achivementHdrView.frame.origin.y + self.achivementHdrView.frame.size.height + 0, width: self.achivementTf.frame.size.width, height: self.achivementTf.frame.size.height)
        
        
        self.heightDisplayHolderView.frame = CGRect(x: self.heightDisplayHolderView.frame.origin.x, y: self.achivementTf.frame.origin.y + self.achivementTf.frame.size.height + 25, width: self.heightDisplayHolderView.frame.size.width, height: self.heightDisplayHolderView.frame.size.height)
        
        
        self.weightHolderView.frame = CGRect(x: self.weightHolderView.frame.origin.x, y: self.heightDisplayHolderView.frame.origin.y + self.heightDisplayHolderView.frame.size.height + 25, width: self.weightHolderView.frame.size.width, height: self.weightHolderView.frame.size.height)
        
        
        self.committedHdrView.frame = CGRect(x: self.committedHdrView.frame.origin.x, y: self.weightHolderView.frame.origin.y + self.weightHolderView.frame.size.height + 25, width: self.committedHdrView.frame.size.width, height: self.committedHdrView.frame.size.height)
        
        
        self.committedRadioView.frame = CGRect(x: self.committedRadioView.frame.origin.x, y: self.committedHdrView.frame.origin.y + self.committedHdrView.frame.size.height + 0, width: self.committedRadioView.frame.size.width, height: self.committedRadioView.frame.size.height)
        
        
        
        self.gpaYearHolderView.frame = CGRect(x: self.gpaYearHolderView.frame.origin.x, y: self.committedRadioView.frame.origin.y + self.committedRadioView.frame.size.height + 25, width: self.gpaYearHolderView.frame.size.width, height: self.gpaYearHolderView.frame.size.height)
        
        
    }
    
    
    func getPositionVal(){
        
        AppUtility?.startLoader(view: self.view)
        
        ApiHandler.sharedInstance.getPosition(idStr: self.selectedSportsId) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    AppUtility?.stopLoader(view: self.view)
                   // print("Success: ",response as Any)
                    let tempDataArray = response!.value(forKey: "data") as! NSArray
                    
                    
                    print("tempDataArray Pos Val " , tempDataArray.count)
                    
                    
                    if(tempDataArray.count == 0){
                        self.positionContentView.alpha = 0
                        self.positionHdrView.alpha = 0
                        
                        
                        self.sportsHolderMasterView.frame =  CGRect(x: self.sportsHolderMasterView.frame.origin.x, y: self.sportsHolderMasterView.frame.origin.y, width: self.sportsHolderMasterView.frame.size.width, height: self.sportsContentView.frame.size.height + self.sportsContentView.frame.origin.y)
                        
                        self.allViewHolderView.frame = CGRect(x: self.allViewHolderView.frame.origin.x, y: self.sportsHolderMasterView.frame.origin.y + self.sportsHolderMasterView.frame.size.height + 10, width: self.allViewHolderView.frame.size.width, height: self.allViewHolderView.frame.size.height)
                    }
                    else{
                        self.positionContentView.alpha = 1
                        self.positionHdrView.alpha = 1
                        
                        self.sportsHolderMasterView.frame =  CGRect(x: self.sportsHolderMasterView.frame.origin.x, y: self.sportsHolderMasterView.frame.origin.y, width: self.sportsHolderMasterView.frame.size.width, height: self.positionContentView.frame.size.height + self.positionContentView.frame.origin.y)
                        
                        self.allViewHolderView.frame = CGRect(x: self.allViewHolderView.frame.origin.x, y: self.initSliderHolderRect.origin.y + 10, width: self.allViewHolderView.frame.size.width, height: self.allViewHolderView.frame.size.height)
                    }
                    
                    for obj in tempDataArray {
                        
                        let tempDic : NSDictionary = obj as! NSDictionary
                        let posObj = tempDic["positions"] as! NSDictionary
                        self.posnameArray.add(posObj["name"] as Any)
                        self.posIdArray.add(posObj["id"] as Any)
                        
                        if(self.selectedPosId == posObj["id"] as! String){
                            self.positionContentLbl.text = "  " + (posObj["name"] as! String)
                        }
                    }
                    
                  //  self.showToast(message: "Porfile Upated", font: .systemFont(ofSize: 12))
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    self.showToast(message: response?.value(forKey: "msg") as! String , font: .systemFont(ofSize: 12))
                   // print("!200: ",response as! Any)
                   //
                    
                    
                }
            }
            else{
                AppUtility?.stopLoader(view: self.view)
            }
        }
        
    }
    
    
    
    func fetchSpotsList (){
        AppUtility?.startLoader(view: self.view)
        
        ApiHandler.sharedInstance.getSports() { [self] (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    AppUtility?.stopLoader(view: self.view)
                    //print("Success: ",response as Any)
                    
                    let tempDataArray = response!.value(forKey: "data") as! NSArray
                    
                    for obj in tempDataArray {
                        
                        let tempDic : NSDictionary = obj as! NSDictionary
                        let sportObj = tempDic["Sport"] as! NSDictionary
                        self.sportsNameArray.add(sportObj["name"] as Any)
                        self.sportsIdArray.add(sportObj["id"] as Any)
                    }
                    
                    print("selectedSportsId 222 " ,self.selectedSportsId.count)
                    if(self.selectedSportsId.count == 0){
                        self.sportsContentLbl.text  = "  " + (self.sportsNameArray[0] as! String)
                        self.selectedSportsId = (self.sportsIdArray[0] as! String)
                    }
                    
                    if(isAthelete){
                        self.getPositionVal()
                    }
                    else{
                        self.positionContentView.alpha = 0
                        self.positionHdrView.alpha = 0
                        
                        
                        self.sportsHolderMasterView.frame =  CGRect(x: self.sportsHolderMasterView.frame.origin.x, y: self.sportsHolderMasterView.frame.origin.y, width: self.sportsHolderMasterView.frame.size.width, height: self.sportsContentView.frame.size.height + self.sportsContentView.frame.origin.y)
                        
                        self.allViewHolderView.frame = CGRect(x: self.allViewHolderView.frame.origin.x, y: self.sportsHolderMasterView.frame.origin.y + self.sportsHolderMasterView.frame.size.height + 10, width: self.allViewHolderView.frame.size.width, height: self.allViewHolderView.frame.size.height)
                    }
                    
                    
                   // print("sportsArray " , self.sportsNameArray)
                   // print("sportsIdArray " , self.sportsIdArray)
                    
                    
                  //  self.showToast(message: "Porfile Upated", font: .systemFont(ofSize: 12))
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    self.showToast(message: response?.value(forKey: "msg") as! String , font: .systemFont(ofSize: 12))
                   // print("!200: ",response as! Any)
                   //
                }
            }
        }
    } // end of fetchSpotsList
    
    
    @objc func handleTapOnSports(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("tap on label, open handleTapOnSports")
        sportsDropDown.dataSource = self.sportsNameArray as! [String]//4
        sportsDropDown.anchorView = (self.sportsContentView!) //5
        sportsDropDown.bottomOffset = CGPoint(x: 0, y: self.sportsContentView.frame.size.height) //6
        sportsDropDown.show() //7
        sportsDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              //sender.setTitle(item, for: .normal) //9
                self!.sportsContentLbl.text = "  " + item
                self!.selectedSportsId = (self!.sportsIdArray[index] as! String)
            
                self!.positionContentLbl.text = "  POSITION"
                self!.selectedPosId = ""
                if(self!.isAthelete){
                    self!.getPositionVal()
                }
                
            // getPosition
            // call postion api
            }
    }
    
    @objc func handleTapOnPosition(_ sender: UITapGestureRecognizer? = nil) {
        
        
        positionDropDown.dataSource = self.posnameArray as! [String]//4
        positionDropDown.anchorView = (self.positionContentView!) //5
        positionDropDown.bottomOffset = CGPoint(x: 0, y: self.positionContentView.frame.size.height) //6
        positionDropDown.show() //7
        positionDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              //sender.setTitle(item, for: .normal) //9
                self!.positionContentLbl.text = "  " + item
                self!.selectedPosId = (self!.posIdArray[index] as! String)
            }
    }
    
    
    
    @objc func handleTapOnHeightFeeet(_ sender: UITapGestureRecognizer? = nil) {
        
        if(!isCoach){
            dropDownHtFt.dataSource = self.heightValArray//4
            dropDownHtFt.anchorView = (self.heightInFeetTF!) //5
            dropDownHtFt.bottomOffset = CGPoint(x: 0, y: self.heightInFeetTF.frame.size.height) //6
            dropDownHtFt.show() //7
            dropDownHtFt.selectionAction = { [weak self] (index: Int, item: String) in //8
                  guard let _ = self else { return }
                  //sender.setTitle(item, for: .normal) //9
                    self!.heightInFeetTF.text = item
                }
        }
        
       
        
    }
    
    @objc func handleTapOnHeightIncf(_ sender: UITapGestureRecognizer? = nil) {
        
        if(!isCoach){
            dropDownHtInch.dataSource = self.heightIncValArray//4
            dropDownHtInch.anchorView = (self.heightInInchTF!) //5
            dropDownHtInch.bottomOffset = CGPoint(x: 0, y: self.heightInInchTF.frame.size.height) //6
            dropDownHtInch.show() //7
            dropDownHtInch.selectionAction = { [weak self] (index: Int, item: String) in //8
                  guard let _ = self else { return }
                  //sender.setTitle(item, for: .normal) //9
                    self!.heightInInchTF.text = item
                }
        }
      
    }
    
    @objc func handleTapOnGpa(_ sender: UITapGestureRecognizer? = nil) {
        print("handleTapOnGpa")
        dropDownGpa.dataSource = self.gpavalArray//4
        dropDownGpa.anchorView = (self.gpaTf!) //5
        dropDownGpa.bottomOffset = CGPoint(x: 0, y: self.gpaTf.frame.size.height) //6
        dropDownGpa.show() //7
        dropDownGpa.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              //sender.setTitle(item, for: .normal) //9
                self!.gpaTf.text = item
            }
        
    }
    
    @objc func handleTapOnGradYr(_ sender: UITapGestureRecognizer? = nil) {
        print("handleTapOnGradYr")
        dropDownGradYear.dataSource = self.gradYrValArray//4
        dropDownGradYear.anchorView = (self.graduatingYrTf!) //5
        dropDownGradYear.bottomOffset = CGPoint(x: 0, y: self.graduatingYrTf.frame.size.height) //6
        dropDownGradYear.show() //7
        dropDownGradYear.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              //sender.setTitle(item, for: .normal) //9
                self!.graduatingYrTf.text = item
            }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            // return NO to disallow editing.
            print("TextField should begin editing method called isCoach " , isCoach)
        if(isCoach){
            return true
        }
        else{
            return false
        }
            
    }
    
    func applyLeftPadding(tf:UITextField){
        
        tf.layer.cornerRadius = 4.0
        tf.clipsToBounds = true
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height:tf.frame.height))
        tf.leftViewMode = .always
        tf.leftView = containerView
    }
    
    
    //MARK:- ACTION
    
    @objc func profileImage(tapGestureRecognizer: UITapGestureRecognizer)
    {
        // Your action
        ImagePickerManager().pickImage(self){ image in
            //here is the image

            self.profilePicData = (image.jpegData(compressionQuality: 0.1)?.base64EncodedString())!
            print("profilePicData: ",self.profilePicData)
            
            self.addUserImgAPI()
            
        }
    }
    
    func screenSetup(){
        
        print("userData screenSetup " ,userData)
        
        
        if(userData.count > 0){
            
           
            
            let userObj = userData[0]
            
            print("ProfilePic URL " , AppUtility?.detectURL(ipString: userObj.userProfile_pic))
            self.profileTypeLbl.text = userObj.user_type
            self.profileImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.profileImage.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: userObj.userProfile_pic))!), placeholderImage: UIImage(named:"noUserImg"))
            
            self.nameTF.text = userObj.username
            self.first_nameTF.text = userObj.first_name
            self.second_nameTF.text = userObj.last_name
            self.bioTxtView.text = userObj.bio
            self.websiteTF.text = userObj.website
            
            self.cityTF.text = userObj.user_city
            self.stateTF.text = userObj.user_state
            
            
            self.heightInFeetTF.text = userObj.height
            self.heightInInchTF.text = userObj.height_inch
            
            print("selectedSportsId 111" )
            
            self.sportsContentLbl.text = "  " +  userObj.sport_name
            self.selectedSportsId = userObj.sport_id
            
            
            self.selectedPosId = userObj.position_id
            
            self.weightTf.text = userObj.weight
            self.achivementTf.text = userObj.achievement
            self.graduatingYrTf.text = userObj.graduating_year
            self.gpaTf.text = userObj.gpa
            
            
            if(self.bioTxtView.text.count == 0){
                self.bioTxtView.text = "Bio"
                self.bioTxtView.textColor = UIColor.lightGray
            }
            
            if(userObj.user_type == "Spectator" || userObj.user_type == "Youth"){
                self.weightHolderView.frame = self.cityHolderView.frame
                
                self.cityHolderView.alpha = 0
                self.stateHolderView.alpha = 0
                self.achivementHdrView.alpha = 0
                self.achivementTf.alpha = 0
                self.heightDisplayHolderView.alpha = 0
                self.committedHdrView.alpha = 0
                self.committedRadioView.alpha = 0
                self.gpaYearHolderView.alpha = 0
            }
            else if(userObj.user_type == "Coach/Scout/Talent Acquisition"){
                isCoach = true
                //self.heightDisplayHolderView.alpha = 0
                self.committedHdrView.alpha = 0
                self.committedRadioView.alpha = 0
                self.gpaYearHolderView.alpha = 0
                
                self.weightTf.alpha = 0.0
                self.weightHolderView.alpha = 0.0
                
                self.htInFeetHdrLbl.text = "University"
                self.htInInchHdrLbl.text = "Teams"
                
                self.heightInFeetTF.keyboardType = UIKeyboardType.default
                self.heightInInchTF.keyboardType = UIKeyboardType.default
                
                self.heightInFeetTF.placeholder = "University"
                self.heightInInchTF.placeholder = "Teams"
                
                self.heightInFeetTF.text = userObj.university
                self.heightInInchTF.text = userObj.teams
                
                self.heightInFeetTF.backgroundColor = UIColor.white
                self.heightInInchTF.backgroundColor = UIColor.white
                
                self.bottomBorder(tf: self.heightInFeetTF)
                self.bottomBorder(tf: self.heightInInchTF)
                
                self.heightInFeetTF.textColor = UIColor.black
                self.heightInInchTF.textColor = UIColor.black
                
                
            }
            else{
                isAthelete = true
            }
            
            
            
            
            self.adjustFrames(textView: self.bioTxtView)
        }
        
        
    }
    
    func bottomBorder(tf:UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: tf.frame.height - 1, width: tf.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.black.cgColor
        tf.borderStyle = UITextField.BorderStyle.none
        tf.layer.addSublayer(bottomLine)
    }
    
    
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        guard (AppUtility?.validateUsername(str: nameTF.text!)) == true else {
            self.showToast(message: "Invalid Username", font: .systemFont(ofSize: 12))
            return
        }
        guard (AppUtility?.validateUsername(str: first_nameTF.text!)) == true else {
            self.showToast(message: "Invalid First Name", font: .systemFont(ofSize: 12))
            return
        }
        guard (AppUtility?.validateUsername(str: first_nameTF.text!)) == true else {
            self.showToast(message: "Invalid Second Name", font: .systemFont(ofSize: 12))
            return
        }
        addProfileDataAPI()
    }
    
    @IBAction func selectedButtonPressed(_ sender: UIButton) {
        
        selectedbtn.setImage(UIImage(named: "selected"), for: .normal)
        unselectedbtn.setImage(UIImage(named: "unselected"), for: .normal)
        
        isMale = true
        
    }
    
    
    @IBAction func unselectedButtonPressed(_ sender: UIButton) {
        
        unselectedbtn.setImage(UIImage(named: "selected"), for: .normal)
        selectedbtn.setImage(UIImage(named: "unselected"), for: .normal)
        
        isMale = false
    }
    
    func addProfileDataAPI(){ // modify here Aniruddha
        let userObj = userData[0]
        AppUtility?.startLoader(view: self.view)
        let username = self.nameTF.text
        let firstName = self.first_nameTF.text
        let lastName = self.second_nameTF.text
        let userID = UserDefaults.standard.string(forKey: "userID")!
        let web = self.websiteTF.text
        
        var bio = ""
        
        if(self.bioTxtView.text != "Bio"){
            bio = self.bioTxtView.text
        }
        
        
        var gender = "Male"
        if isMale == false{
            gender = "female"
        }
        var commitedval = "Y"
        
        if isCommited == false{
            commitedval = "N"
        }
        else{
            commitedval = "Y"
        }
        
        let user_city = self.cityTF.text
        let user_state = self.stateTF.text
        let height = self.heightInFeetTF.text
        let height_inch = self.heightInInchTF.text
        
        var htInIchVal = ""
        var htInFeetVal = ""
        
        var universityVal = ""
        var teamsVal = ""
        
        
        if(isCoach){
            universityVal = self.heightInFeetTF.text!
            teamsVal = self.heightInInchTF.text!
        }
        else{
            htInFeetVal = self.heightInFeetTF.text!
            htInIchVal = self.heightInInchTF.text!
        }
            
        ApiHandler.sharedInstance.editProfile(username: username ?? "", user_id: userID , first_name: firstName ?? "", last_name: lastName ?? "", gender: gender , website: web ?? "", bio: bio ?? "" ,user_city:user_city ?? "",user_state:user_state ?? "" , height: (htInFeetVal) , height_inch :htInIchVal,achievement:self.achivementTf.text!,sport_id:self.selectedSportsId,position_id:self.selectedPosId,weight:self.weightTf.text!,gpa:self.gpaTf.text!,graduating_year:self.graduatingYrTf.text!,committed:commitedval,university:universityVal,teams:teamsVal,uni_state:userObj.uni_state ) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    AppUtility?.stopLoader(view: self.view)
                    
                    self.showToast(message: "Porfile Upated", font: .systemFont(ofSize: 12))
                    sleep(2)
                    self.goBckToPrev()
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    self.showToast(message: response?.value(forKey: "msg") as! String , font: .systemFont(ofSize: 12))
                   // print("!200: ",response as! Any)
                   //
                    
                    
                }
            }
        }
    }
    
    func goBckToPrev (){
        self.navigationController?.popViewController(animated: true)
    }
    func addUserImgAPI(){
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.addUserImage(user_id: UserDefaults.standard.string(forKey: "userID")!, profile_pic: ["file_data":self.profilePicData]) { (isSuccess, response) in
            if response?.value(forKey: "code") as! NSNumber == 200{
                AppUtility?.stopLoader(view: self.view)
                let msgDict = response?.value(forKey: "msg") as! NSDictionary
                let userDict = msgDict.value(forKey: "User") as! NSDictionary
                let profImgUrl = userDict.value(forKey: "profile_pic") as! String
                
                self.profileImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.profileImage.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: profImgUrl))!), placeholderImage: UIImage(named:"noUserImg"))
                
            }else{
                AppUtility?.stopLoader(view: self.view)
                self.showToast(message: "Error Occur", font: .systemFont(ofSize: 12))
            }
        }
    } 
}
