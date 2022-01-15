//
//  AdvanceFilterViewController.swift
//  Draftys
//
//  Created by Aniruddha on 14/07/21.
//  Copyright © 2021 Junaid Kamoka. All rights reserved.
//

import UIKit
import DropDown
import RangeSeekSlider

class AdvanceFilterViewController: UIViewController, RangeSeekSliderDelegate {
    
    
    //MARK:- Outlets
    
    @IBAction func searchBtnClick(_ sender: Any) {
        // advanceSearch
        self.performAdvanceSearch()
    }
    
    @IBOutlet weak var searchBtnObj: UIButton!
    @IBAction func backBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBOutlet weak var masterHolderScrollView: UIScrollView!
    
    @IBOutlet weak var posHdrView: UIView!
    @IBOutlet weak var sportsHolderView: UIView!
    @IBOutlet weak var sportsLbl: UILabel!
    
    @IBOutlet weak var positionHolderView: UIView!
    @IBOutlet weak var positionLbl: UILabel!
    
    @IBOutlet weak var allSliderHolderView: UIView!
    
    
    @IBOutlet weak var graduateYearSlider: RangeSeekSlider!
    

    
    @IBOutlet weak var gpaSlider: RangeSeekSlider!
    
    @IBOutlet weak var htFeetSlider: RangeSeekSlider!
    
    
    @IBOutlet weak var htInchSlider: RangeSeekSlider!
    
    @IBOutlet weak var weightSlider: RangeSeekSlider!

    
    @IBOutlet weak var weightHolderView: UIView!
    
    @IBOutlet weak var committedHolderView: UIView!
    
    @IBAction func yesBtnClick(_ sender: Any) {
        
        self.yesBtnObj.setImage(UIImage(named: "selected"), for: .normal)
        self.noBtnObj.setImage(UIImage(named: "unselected"), for: .normal)
        self.isCommitedStr = "Y"
    }
    
    @IBOutlet weak var yesBtnObj: UIButton!
    
    @IBAction func noBtnClick(_ sender: Any) {
        
        self.yesBtnObj.setImage(UIImage(named: "unselected"), for: .normal)
        self.noBtnObj.setImage(UIImage(named: "selected"), for: .normal)
        self.isCommitedStr = "N"
    }
    
    @IBOutlet weak var noBtnObj: UIButton!
    
    
    
    var sportsNameArray : NSMutableArray = []
    var sportsIdArray : NSMutableArray = []
    let sportsDropDown = DropDown()
    var selectedSportsId = ""
    var isCommitedStr = "Y"
    
    var initSliderHolderRect :CGRect = CGRect.init()
    
    let positionDropDown = DropDown()
    var selectedPosId = ""
    var posnameArray : NSMutableArray = []
    var posIdArray : NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBtnObj.layer.cornerRadius = 8.0
        self.searchBtnObj.clipsToBounds = true
        // Do any additional setup after loading the view.
        // getSports
        self.positionLbl.layer.cornerRadius = 4.0
        self.positionLbl.clipsToBounds = true
        
        self.sportsLbl.layer.cornerRadius = 4.0
        self.sportsLbl.clipsToBounds = true
        
        
        self.setUpSliders(slider: self.graduateYearSlider, minVal: 1960, maxVal: 2031)
        self.setUpSliders(slider: self.gpaSlider, minVal: 2, maxVal: 4)
        self.setUpSliders(slider: self.htFeetSlider, minVal: 3, maxVal: 8)
        self.setUpSliders(slider: self.htInchSlider, minVal: 0, maxVal: 11)
        self.setUpSliders(slider: self.weightSlider, minVal: 30, maxVal: 500)
        
        let tapIOnSportsView = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnSports(_:)))
        self.sportsHolderView.addGestureRecognizer(tapIOnSportsView)
        
        
        let tapIOnPositionView = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnPosition(_:)))
        self.positionHolderView.addGestureRecognizer(tapIOnPositionView)
        
        
        self.initSliderHolderRect = self.allSliderHolderView.frame
        
        self.masterHolderScrollView.contentSize.height = self.allSliderHolderView.frame.origin.y + self.allSliderHolderView.frame.size.height + 50;
        
        
        self.fetchSpotsList()
    }
    
    
  
    
    func setUpSliders(slider:RangeSeekSlider , minVal:CGFloat , maxVal:CGFloat){
        slider.delegate = self
        slider.minValue = minVal
        slider.maxValue = maxVal
        slider.selectedMinValue = minVal
        slider.selectedMaxValue = maxVal
        if(slider == self.gpaSlider){
          //  slider.interva
        }
    }
    
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === self.graduateYearSlider {
            
            print("Standard slider updated. Min Value: \(Int(minValue)) Max Value: \(Int(maxValue))")
            
            print("self.graduateYearSlider.selectedMinValue " , self.graduateYearSlider.selectedMinValue)
        }
        
        else if slider === self.gpaSlider{
            print("gpaSlider Min" , Double(round(100*self.gpaSlider.selectedMinValue)/100) )
            print("gpaSlider Max" , Double(round(100*self.gpaSlider.selectedMaxValue)/100) )
        }
        
        else if slider === self.gpaSlider{
            print("self gpaSlider " , Int(self.gpaSlider.selectedMinValue))
        }
        
        else if slider === self.htInchSlider{
            print("self htInchSlider " , Int(self.htInchSlider.selectedMinValue))
        }
    }
    
    @objc func handleTapOnSports(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("tap on label, open handleTapOnSports")
        sportsDropDown.dataSource = self.sportsNameArray as! [String]//4
        sportsDropDown.anchorView = (self.sportsHolderView!) //5
        sportsDropDown.bottomOffset = CGPoint(x: 0, y: self.sportsHolderView.frame.size.height) //6
        sportsDropDown.show() //7
        sportsDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              //sender.setTitle(item, for: .normal) //9
                self!.sportsLbl.text = "  " + item
                self!.selectedSportsId = (self!.sportsIdArray[index] as! String)
            
                self!.positionLbl.text = "  POSITION"
                self!.selectedPosId = ""
                self!.getPositionVal()
            // getPosition
            // call postion api
            }
    }
    
    @objc func handleTapOnPosition(_ sender: UITapGestureRecognizer? = nil) {
        
        
        positionDropDown.dataSource = self.posnameArray as! [String]//4
        positionDropDown.anchorView = (self.positionHolderView!) //5
        positionDropDown.bottomOffset = CGPoint(x: 0, y: self.positionHolderView.frame.size.height) //6
        positionDropDown.show() //7
        positionDropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
              guard let _ = self else { return }
              //sender.setTitle(item, for: .normal) //9
                self!.positionLbl.text = "  " + item
                self!.selectedPosId = (self!.posIdArray[index] as! String)
            }
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
                        self.positionHolderView.alpha = 0
                        self.posHdrView.alpha = 0
                        self.allSliderHolderView.frame = CGRect(x: self.allSliderHolderView.frame.origin.x, y: self.posHdrView.frame.origin.y, width: self.allSliderHolderView.frame.size.width, height: self.allSliderHolderView.frame.size.height)
                    }
                    else{
                        self.positionHolderView.alpha = 1
                        self.posHdrView.alpha = 1
                        self.allSliderHolderView.frame = CGRect(x: self.allSliderHolderView.frame.origin.x, y: self.initSliderHolderRect.origin.y, width: self.allSliderHolderView.frame.size.width, height: self.allSliderHolderView.frame.size.height)
                    }
                    
                    for obj in tempDataArray {
                        
                        let tempDic : NSDictionary = obj as! NSDictionary
                        let posObj = tempDic["positions"] as! NSDictionary
                        self.posnameArray.add(posObj["name"] as Any)
                        self.posIdArray.add(posObj["id"] as Any)
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
                    
                    
                    self.sportsLbl.text  = "  " + (self.sportsNameArray[0] as! String)
                    self.selectedSportsId = (self.sportsIdArray[0] as! String)
                    self.getPositionVal()
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
    
    
    func performAdvanceSearch(){
        
        print("self.selectedSportsId " , self.selectedSportsId)
        print("self.selectedPosId " , self.selectedPosId)
        
            AppUtility?.startLoader(view: self.view)
            
        ApiHandler.sharedInstance.advanceSearch(sport_id : self.selectedSportsId , position_id:self.selectedPosId,mingyear:String(Int(self.graduateYearSlider.selectedMinValue)), maxgyear:String(Int(self.graduateYearSlider.selectedMaxValue)), mingpa:String(Float(self.gpaSlider.selectedMinValue)) , maxgpa: String(Float(self.gpaSlider.selectedMaxValue)),minweight: String(Int(self.weightSlider.selectedMinValue)),maxweight: String(Int(self.weightSlider.selectedMaxValue)),minheight: String(Int(self.htFeetSlider.selectedMinValue)),maxheight: String(Int(self.htFeetSlider.selectedMaxValue)), committed:self.isCommitedStr ,minheightinch: String(Int(self.htInchSlider.selectedMinValue)) ,maxheightinch:String(Int(self.htInchSlider.selectedMaxValue))) { (isSuccess, response) in
                if isSuccess{
                    if response?.value(forKey: "code") as! NSNumber == 200{
                        AppUtility?.stopLoader(view: self.view)
                       // print("Success advance search: ",response as Any)
                        //
                        
                        let dataArray  = response!["data"] as! NSArray
                        
                        print("dataArray " , dataArray)
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchedProfileViewController") as! SearchedProfileViewController
                       
                        vc.profileDataArray = dataArray
                        //                 vc.phoneNo = phoneNoNew
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                       // self.navigationController?.popViewController(animated: true)
                      //  self.showToast(message: "Porfile Upated", font: .systemFont(ofSize: 12))
                    }else{
                        AppUtility?.stopLoader(view: self.view)
                        self.showToast(message: response?.value(forKey: "msg") as! String , font: .systemFont(ofSize: 12))
                       // print("!200: ",response as! Any)
                       //
                        
                        
                    }
                }
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
