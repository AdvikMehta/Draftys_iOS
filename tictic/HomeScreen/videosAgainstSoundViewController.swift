//
//  videosAgainstSoundViewController.swift
//  Draftys
//
//  Created by Aniruddha on 30/09/21.
//  Copyright © 2021 Junaid Kamoka. All rights reserved.
//

import UIKit
import SDWebImage

class videosAgainstSoundViewController: UIViewController {
    @IBOutlet weak var topViewObj: UIView!
    
    @IBOutlet weak var backBtnObj: UIButton!
    
    @IBAction func backBtnClick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    

    @IBOutlet weak var masterContenScrollView: UIScrollView!
    
    @IBOutlet weak var btmBtnHolderView: UIView!
    
    @IBAction func saveBtnClick(_ sender: Any) {
    }
    
    @IBAction func createBtnClick(_ sender: Any) {
        
        
        let audioUrlStr = self.soundFileObj["audio"] as! String
        let audioNameStr = self.soundFileObj["name"] as! String
        
        UserDefaults.standard.set(audioUrlStr, forKey: "url")
        UserDefaults.standard.set(audioNameStr, forKey: "selectedSongName")
        
        
        let vc1 = storyboard?.instantiateViewController(withIdentifier: "actionMediaVC") as! actionMediaViewController
        //UserDefaults.standard.set("", forKey: "url")
        vc1.modalPresentationStyle = .fullScreen
        self.present(vc1, animated: true, completion: nil)
    }
    
    @IBOutlet weak var saveBtnObj: UIButton!
    
    @IBOutlet weak var createBtnObj: UIButton!
    
    
    var startpointStr = ""
    var deviceIdStr = ""
    var soundIdStr = ""
    
    var initYPos = 5.0
    var videosDataArr = [videoMainMVC]()
    
    var soundFileObj : NSDictionary = [:]
    
    var vdoAgainstSoundArray : NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.manageBtnStyle(btnObj: self.saveBtnObj)
        self.manageBtnStyle(btnObj: self.createBtnObj)
        
        print("startpointStr " , startpointStr)
        print("deviceIdStr " , deviceIdStr)
        print("soundIdStr " , soundIdStr)
        //soundIdStr = "4"
        self.getVideoAgainstSound()
        // Do any additional setup after loading the view.
    }
    
    func manageBtnStyle(btnObj:UIButton){
        btnObj.layer.cornerRadius = 22.0
        btnObj.clipsToBounds = true
    }
    
    
    func getVideoAgainstSound(){
        if(UserDefaults.standard.string(forKey: "userID") == "" || UserDefaults.standard.string(forKey: "userID") == nil){
                        
            newLoginScreenAppear()
        }else{
        print("userid: ",UserDefaults.standard.string(forKey: "userID")!)
        AppUtility?.startLoader(view: self.view)

        ApiHandler.sharedInstance.showVideosAgainstSound(sound_id: soundIdStr, starting_point: startpointStr, device_id: deviceIdStr, completionHandler: { (isSuccess, response) in
            if isSuccess{
                AppUtility?.stopLoader(view: self.view)
                let code = response?.value(forKey: "code") as! NSNumber

                if code == 200{
                    let msgArr = response?.value(forKey: "msg") as! NSArray
                    print("msgArr " , msgArr)
                    self.vdoAgainstSoundArray = msgArr
                    self.populateFileContent()
                   /* for msgObj in msgArr{
                        let videosData = msgObj as! NSDictionary
                    }*/
                }

            }else{
                self.showToast(message: "Failed to load notifications", font: .systemFont(ofSize: 12))
                AppUtility?.stopLoader(view: self.view)
            }
            AppUtility?.stopLoader(view: self.view)
        })
        }
       
    }
    
    func newLoginScreenAppear(){
        let navController = UINavigationController.init(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "newLoginVC"))
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .overFullScreen

        self.present(navController, animated: true, completion: nil)
    }

    func populateFileContent(){
     
        let widthVal = Double(self.masterContenScrollView.frame.size.width)
       // print("Array Count " , self.vdoAgainstSoundArray.count)
        
        for i in 0...self.vdoAgainstSoundArray.count - 1 {
            //YOUR LOGIC....
            let tempObj = self.vdoAgainstSoundArray[i] as! NSDictionary
            
            
            self.soundFileObj = tempObj["Sound"] as! NSDictionary
            let soundObj  = tempObj["Sound"] as! NSDictionary
            let vdoObj  = tempObj["Video"] as! NSDictionary
            let userObj  = tempObj["User"] as! NSDictionary
        
            let tempSoundScrollView = UIScrollView()
               tempSoundScrollView.frame = CGRect(x: 5, y: initYPos, width: widthVal, height: 150  )
               //tempSoundScrollView.backgroundColor = UIColor.red
               
               
               let thumnailImgView = UIImageView()
               thumnailImgView.frame = CGRect(x: 0, y: 0, width: 100, height: tempSoundScrollView.frame.size.height)
               //thumnailImgView.backgroundColor = UIColor.cyan
            
                let soundThumb = AppUtility?.detectURL(ipString: soundObj["thum"] as! String);
            
                thumnailImgView.sd_setImage(with: URL(string:soundThumb!), placeholderImage: UIImage(named:"noUserImg"))
            
                tempSoundScrollView.addSubview(thumnailImgView)
            
            
                
            
                 let uploadedByLbl = UILabel()
                 uploadedByLbl.frame = CGRect(x: thumnailImgView.frame.size.width + 10, y: 0, width: 250, height: 40)
            
                uploadedByLbl.text = (soundObj["name"] as! String)
                uploadedByLbl.font = UIFont.boldSystemFont(ofSize: 16.0)
            
                tempSoundScrollView.addSubview(uploadedByLbl)
            
            
            
                let desTxtLbl = UILabel()
                desTxtLbl.frame = CGRect(x: thumnailImgView.frame.size.width + 10, y: 45, width: 200, height: 40)
                desTxtLbl.text = (soundObj["description"] as! String)
            
                tempSoundScrollView.addSubview(desTxtLbl)
            
               self.masterContenScrollView.addSubview(tempSoundScrollView)
               
               
               initYPos = Double(CGFloat(initYPos) +  tempSoundScrollView.frame.size.height + 5)
               
               
               
               let tempVdoScrollView = UIScrollView()
               
               tempVdoScrollView.frame = CGRect(x: 5, y: initYPos, width: 150, height: 150  )
               
              // tempVdoScrollView.backgroundColor = UIColor.blue
            
                let thumVdoGif = UIImageView()
                thumVdoGif.frame = CGRect(x: 0, y: 0, width: tempVdoScrollView.frame.size.width, height: tempVdoScrollView.frame.size.height)
                //thumVdoGif.backgroundColor = UIColor.cyan
            
            
                let vdoThumGif = AppUtility?.detectURL(ipString: vdoObj["gif"] as! String);
        
                thumVdoGif.sd_setImage(with: URL(string:vdoThumGif!), placeholderImage: UIImage(named:"noUserImg"))
            
        
                tempVdoScrollView.addSubview(thumVdoGif)
            
            
                let displayViewCount  = UIView()
                displayViewCount.frame = CGRect(x: 0, y: 100, width: tempVdoScrollView.frame.size.width, height: 50)
                displayViewCount.backgroundColor = UIColor.clear
                tempVdoScrollView.addSubview(displayViewCount)
            
                let eyeIconImageView  = UIImageView()
                eyeIconImageView.frame = CGRect(x: 8, y: 20, width: 20, height: 20)
                eyeIconImageView.image = UIImage(named: "viewEyeIcon.png")
                displayViewCount.addSubview(eyeIconImageView)
            
            
            
                let viewEyeCountLbl  = UILabel()
                viewEyeCountLbl.frame = CGRect(x: 32, y: 20, width: 70, height: 20)
                viewEyeCountLbl.textColor = UIColor.white
                viewEyeCountLbl.text = vdoObj["view"] as? String
                displayViewCount.addSubview(viewEyeCountLbl)
               
            
            
               self.masterContenScrollView.addSubview(tempVdoScrollView)
               
            
                let tapOnVdo = VdoTapGesture(target: self, action: #selector(self.handleTapOnVdo(_:)))
            
                tempVdoScrollView.addGestureRecognizer(tapOnVdo)
                tapOnVdo.paramObj = vdoObj
                tapOnVdo.paramUserObj = userObj
                tapOnVdo.paramSoundObj = soundObj
               
               initYPos = Double(CGFloat(initYPos) + tempVdoScrollView.frame.size.height + 15)
               //frame: CGRect(x: 0, y: initYPos, width: self.masterContenScrollView.frame.size.width, height: 150)
        
        }
        
        
        self.masterContenScrollView.contentSize.height = CGFloat(initYPos + 25)
        
        
    }
    
    
    
    @objc func handleTapOnVdo(_ sender: VdoTapGesture? = nil) {
        // handling code
        print("handleTapOnVdo " , sender!.paramObj)
        let videoObj = sender!.paramObj
        let userObj = sender!.paramUserObj
        let soundObj = sender!.paramSoundObj
        
        
        
        let videoUrl = videoObj.value(forKey: "video") as! String
        let videoThum = videoObj.value(forKey: "thum") as! String
        let videoGif = videoObj.value(forKey: "gif") as! String
        let videoLikes = "\(videoObj.value(forKey: "like_count") ?? "")"
        let videoComments = "\(videoObj.value(forKey: "comment_count") ?? "")"
        let like = "\(videoObj.value(forKey: "like") ?? "")"
        let allowComment = videoObj.value(forKey: "allow_comments") as! String
        let videoID = videoObj.value(forKey: "id") as! String
        let videoDesc = videoObj.value(forKey: "description") as! String
        let allowDuet = videoObj.value(forKey: "allow_duet") as! String
        let created = videoObj.value(forKey: "created") as! String
        let views = "\(videoObj.value(forKey: "view") ?? "")"
        let duetVidID = videoObj.value(forKey: "duet_video_id")
        
        let userID = userObj.value(forKey: "id") as! String
        let username = userObj.value(forKey: "username") as! String
        let userOnline = userObj.value(forKey: "online") as! String
        let userImg = userObj.value(forKey: "profile_pic") as! String
        //                        let followBtn = userObj.value(forKey: "button") as! String
        let verified = userObj.value(forKey: "verified")
        
        let soundID = soundObj.value(forKey: "id") as? String
        let soundName = soundObj.value(forKey: "name") as? String
        
        let video = videoMainMVC(videoID: videoID, videoUserID: "", fb_id: "", description: videoDesc, videoURL: videoUrl, videoTHUM: videoThum, videoGIF: videoGif, view: views, section: "", sound_id: "\(soundID ?? "")", privacy_type: "", allow_comments: allowComment, allow_duet: allowDuet, block: "", duet_video_id: "", old_video_id: "", created: created, like: like, favourite: "", comment_count: videoComments, like_count: videoLikes, followBtn: "", duetVideoID: "\(duetVidID!)", userID: userID, first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImg, role: "", username: username, social: "", device_token: "", videoCount: "", verified: "\(verified ?? "")", soundName: "\(soundName ?? "")")
        
        self.videosDataArr.append(video)
        let indexPath = IndexPath(row: 0, section: 0)
        
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "homeFeedVC") as! homeFeedViewController
        vc.userVideoArr = videosDataArr
        vc.indexAt = indexPath
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
        
        
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

class VdoTapGesture: UITapGestureRecognizer {
    var paramObj = NSDictionary()
    var paramUserObj =  NSDictionary()
    var paramSoundObj = NSDictionary()
}
