//
//  newNotificationsViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 27/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class newNotificationsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var notificationTblView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    
    var notificationsArr = [notificationsMVC]()
    var notiVidDataArr = [videoMainMVC]()
    var userData = [userMVC]()
    var startPoint = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserDetails()
      //  print("userObj " , userData)
       /* let userObj = userData[0]
        
        print("userObj " , userData)
        
        if(userObj.user_type == "Youth"){
            
        }
        else{
            getNotifications(startPoint: "\(startPoint)")
        }*/
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func getNotifications(startPoint:String){
                
        print("userid: ",UserDefaults.standard.string(forKey: "userID")!)
        print("userData " , self.userData)
        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showAllNotifications(user_id: UserDefaults.standard.string(forKey: "userID")!, starting_point: "\(startPoint)") { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let resMsg = response?.value(forKey: "msg") as! [[String:Any]]
                    for dic in resMsg{
                        let notiDic = dic["Notification"] as! NSDictionary
                        
//                        let vidDic = dic["Video"] as! NSDictionary
                        let senderDic = dic["Sender"] as! NSDictionary
                        let receiverDic = dic["Receiver"] as! NSDictionary
                        
                        let notiString = notiDic.value(forKey: "string") as! String
                        let type = notiDic.value(forKey: "type") as! String
                        let receiver_id = notiDic.value(forKey: "receiver_id") as! String
                        let sender_id = notiDic.value(forKey: "sender_id") as! String
                        let video_id = notiDic.value(forKey: "video_id") as! String
                        let notiID  = notiDic.value(forKey: "id") as! String
                        
                        let senderUserame  = senderDic.value(forKey: "username") as! String
                        let senderImg = senderDic.value(forKey: "profile_pic") as! String
                        let senderFirstName = senderDic.value(forKey: "first_name") as! String
                        
                        let receiverName = receiverDic.value(forKey: "username") as! String
                        
                        let notiObj = notificationsMVC(notificationString: notiString, id: notiID, sender_id: sender_id, receiver_id: receiver_id, type: type, video_id: video_id, senderName: senderUserame, senderFirstName: senderFirstName, receiverName: receiverName, senderImg: senderImg)
                        
                        self.notificationsArr.append(notiObj)

                    }
                    AppUtility?.stopLoader(view: self.view)
                    self.notificationTblView.reloadData()
                }else{
                    AppUtility?.stopLoader(view: self.view)
//                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    
                    print("!200",response?.value(forKey: "msg"))
                }
            }else{
                self.showToast(message: "Failed to load notifications", font: .systemFont(ofSize: 12))
                AppUtility?.stopLoader(view: self.view)
            }
            AppUtility?.stopLoader(view: self.view)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.notificationsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:FollowTableViewCell = self.notificationTblView.dequeueReusableCell(withIdentifier: "cell01") as! FollowTableViewCell
        
        let obj = self.notificationsArr[indexPath.row]
        
        cell.folow_name.text = obj.senderName
        cell.folow_username.text = obj.notificationString
        if(obj.type == "video_like"){
            cell.foolow_btn_view.alpha = 1
        }else if(obj.type == "video_comment"){
            cell.foolow_btn_view.alpha = 1
        }else{
            cell.foolow_btn_view.alpha = 0
        }
        
        
        let senderImg = AppUtility?.detectURL(ipString: obj.senderImg) 
        cell.follow_img.sd_setImage(with: URL(string:senderImg!), placeholderImage: UIImage(named:"noUserImg"))
        cell.follow_img.layer.cornerRadius = cell.follow_img.frame.size.width / 2
        cell.follow_img.clipsToBounds = true
        
        cell.follow_view.layer.cornerRadius = cell.follow_view.frame.size.width / 2
        cell.follow_view.clipsToBounds = true
        
        cell.foolow_btn_view.layer.cornerRadius = 5
        cell.foolow_btn_view.clipsToBounds = true
        
        cell.btn_follow.tag = indexPath.item
        
        cell.btnWatch.addTarget(self, action: #selector(newNotificationsViewController.btnWatchAction(_:)), for:.touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let obj = notificationsArr[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "newProfileVC") as!  newProfileViewController
        UserDefaults.standard.set(obj.sender_id, forKey: "otherUserID")
        vc.isOtherUserVisting = true
        vc.otherUserID = obj.sender_id
        navigationController?.pushViewController(vc, animated: true)
        

    }
    
    @objc func btnWatchAction(_ sender : UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.notificationTblView)
        let indexPath = self.notificationTblView.indexPathForRow(at:buttonPosition)
        let cell = self.notificationTblView.cellForRow(at: indexPath!) as! FollowTableViewCell
        
        
        self.getVideo(ip:indexPath!)
        
        print("btn watch tapped")

    }
    
    @IBAction func btnInbox(_ sender: Any) {
        
        let userObj = userData[0]
         
         print("userObj " , userData)
         
         if(userObj.user_type == "Youth"){
            self.showToast(message: "This option is not available for you", font: .systemFont(ofSize: 12))
         }
         else{
            let vc = storyboard?.instantiateViewController(identifier: "conversationVC") as! ConversationViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
         }
        
    }
    
    func getVideo(ip:IndexPath){
        AppUtility?.startLoader(view: self.view)
        let obj = notificationsArr[ip.row]
        ApiHandler.sharedInstance.showVideoDetail(user_id: UserDefaults.standard.string(forKey: "userID")!, video_id: obj.video_id) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    let resMsg = response?.value(forKey: "msg") as! NSDictionary
                    
                    let videoDic = resMsg.value(forKey: "Video") as! NSDictionary
                    let userDic = resMsg.value(forKey: "User") as! NSDictionary
                    let soundDic = resMsg.value(forKey: "Sound") as! NSDictionary
                        
                        print("videoDic: ",videoDic)
                        print("userDic: ",userDic)
                        print("soundDic: ",soundDic)
                        
                        let videoURL = videoDic.value(forKey: "video") as! String
                        let desc = videoDic.value(forKey: "description") as! String
                        let allowComments = videoDic.value(forKey: "allow_comments")
                        let videoUserID = videoDic.value(forKey: "user_id")
                        let videoID = videoDic.value(forKey: "id") as! String
                        let allowDuet = videoDic.value(forKey: "allow_duet")
                        
                        //                        not strings
                        let commentCount = videoDic.value(forKey: "comment_count")
                        let likeCount = videoDic.value(forKey: "like_count")
                        let duetVidID = videoDic.value(forKey: "duet_video_id")
                        
                        let userImgPath = userDic.value(forKey: "profile_pic") as! String
                        let userName = userDic.value(forKey: "username") as! String
                        let followBtn = userDic.value(forKey: "button") as! String
                        let uid = userDic.value(forKey: "id") as! String
                        let verified = userDic.value(forKey: "verified")
                        
                        let soundName = soundDic.value(forKey: "name")
                        
                    let videoObj = videoMainMVC(videoID: videoID, videoUserID: "\(videoUserID!)", fb_id: "", description: desc, videoURL: videoURL, videoTHUM: "", videoGIF: "", view: "", section: "", sound_id: "", privacy_type: "", allow_comments: "\(allowComments!)", allow_duet: "\(allowDuet!)", block: "", duet_video_id: "", old_video_id: "", created: "", like: "", favourite: "", comment_count: "\(commentCount!)", like_count: "\(likeCount!)", followBtn: followBtn, duetVideoID: "\(duetVidID!)", userID: uid, first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImgPath, role: "", username: userName, social: "", device_token: "", videoCount: "", verified: "\(verified!)", soundName: "\(soundName!)")
                    
                        self.notiVidDataArr.append(videoObj)
                    
                    print("response@200: ",response!)
                    
                    AppUtility?.stopLoader(view: self.view)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeFeedVC") as! homeFeedViewController
                    vc.userVideoArr = self.notiVidDataArr
                    vc.indexAt = ip
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    AppUtility?.stopLoader(view: self.view)
                    print("!200: ",response as Any)
                }
                

            }else{
                AppUtility?.startLoader(view: self.view)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeFeedVC") as! homeFeedViewController
                vc.userVideoArr = self.notiVidDataArr
                vc.indexAt = ip
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if notificationsArr.isEmpty{
            noDataView.isHidden = false
        }else{
            noDataView.isHidden = true
        }
        
        if indexPath.row == notificationsArr.count - 4{
            self.startPoint+=1
            print("StartPoint: ",startPoint)
                self.getNotifications(startPoint: "\(self.startPoint)")
            print("index@row: ",indexPath.row)
        }
    }
    
    
    
    func getUserDetails(){
        self.userData.removeAll()
        
//        AppUtility?.startLoader(view: view)
        ApiHandler.sharedInstance.showOwnDetail(user_id: UserDefaults.standard.string(forKey: "userID")!) { [self] (isSuccess, response) in
            if isSuccess{
                
                print("response user details: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userObj = userObjMsg.value(forKey: "User") as! NSDictionary
                    
                    let privSettingObj = userObjMsg.value(forKey: "PrivacySetting") as! NSDictionary
                    let pushNotiSettingObj = userObjMsg.value(forKey: "PushNotification") as! NSDictionary
                    
                    //                    MARK:- PRIVACY SETTING DATA
                    let direct_message = privSettingObj.value(forKey: "direct_message") as! String
                    let duet = privSettingObj.value(forKey: "duet") as! String
                    let liked_videos = privSettingObj.value(forKey: "liked_videos") as! String
                    let video_comment = privSettingObj.value(forKey: "video_comment") as! String
                    let videos_download = privSettingObj.value(forKey: "videos_download")
                    let privID = privSettingObj.value(forKey: "id")
                    
                    let privObj = privacySettingMVC(direct_message: direct_message, duet: duet, liked_videos: liked_videos, video_comment: video_comment, videos_download: "\(videos_download!)", id: "\(privID!)")
                   // self.privacySettingData.append(privObj)
                    
                    //                    MARK:- PUSH NOTIFICATION SETTING DATA
                    let cmnt = pushNotiSettingObj.value(forKey: "comments")
                    let direct_messages = pushNotiSettingObj.value(forKey: "direct_messages")
                    let likes = pushNotiSettingObj.value(forKey: "likes")
                    let pushID = pushNotiSettingObj.value(forKey: "id")
                    let new_followers = pushNotiSettingObj.value(forKey: "new_followers")
                    let video_updates = pushNotiSettingObj.value(forKey: "video_updates")
                    let mentions = pushNotiSettingObj.value(forKey: "mentions")
                    
                    let pushObj = pushNotiSettingMVC(comments: "\(cmnt!)", direct_messages: "\(direct_messages!)", likes: "\(likes!)", mentions: "\(mentions!)", new_followers: "\(new_followers!)", video_updates: "\(video_updates!)", id: "\(pushID!)")
                    
                   // self.pushNotiSettingData.append(pushObj)
                    
                    let userImage = (userObj.value(forKey: "profile_pic") as? String)!
                    let userName = (userObj.value(forKey: "username") as? String)!
                    let followers = "\(userObj.value(forKey: "followers_count") ?? "")"
                    let followings = "\(userObj.value(forKey: "following_count") ?? "")"
                    let likesCount = "\(userObj.value(forKey: "likes_count") ?? "")"
                    let videoCount = "\(userObj.value(forKey: "video_count") ?? "")"
                    let firstName = (userObj.value(forKey: "first_name") as? String)!
                    let lastName = (userObj.value(forKey: "last_name") as? String)!
                    let gender = (userObj.value(forKey: "gender") as? String)!
                    let bio = (userObj.value(forKey: "bio") as? String)!
                    let dob = (userObj.value(forKey: "dob") as? String)!
                    let website = (userObj.value(forKey: "website") as? String)!
                    
                    
                    var sport_name = ""
                    
                    if ((userObj.object(forKey: "sport_name")) != nil) {
                        print("response someKey exists")
                        sport_name = (userObj.value(forKey: "sport_name") as? String)!
                    }
                    
                     
                    let userId = (userObj.value(forKey: "id") as? String)!
                    
                    var user_city = ""
                    
                    if ((userObj.object(forKey: "user_city")) != nil)  {
                        print("response someKey exists")
                        
                        if let tempCity = (userObj.object(forKey: "user_city")) as? String
                        {
                            user_city = tempCity
                        }
                        else
                        {
                            user_city = ""
                        }
                        
                    }
                    
                    var user_state = ""
                    
                    if ((userObj.object(forKey: "user_state")) != nil) {
                        print("response someKey exists")
                        
                        if let tempState = (userObj.object(forKey: "user_state")) as? String
                        {
                            user_state = tempState
                        }
                        else
                        {
                            user_state = ""
                        }
                        
                       // user_state = (userObj.value(forKey: "user_state") as? String)!
                    }
                    
                    var height = ""
                    
                    if ((userObj.object(forKey: "height")) != nil) {
                        print("response someKey exists")
                        
                        if let tempHeight = (userObj.object(forKey: "height")) as? String
                        {
                            height = tempHeight
                        }
                        else
                        {
                            height = ""
                        }
                        
                      //  height = (userObj.value(forKey: "height") as? String)!
                    }
                    
                    var height_inch = ""
                    
                    if ((userObj.object(forKey: "height_inch")) != nil) {
                        print("response someKey exists")
                        if let tempHeightInch = (userObj.object(forKey: "height_inch")) as? String
                        {
                            height_inch = tempHeightInch
                        }
                        else
                        {
                            height_inch = ""
                        }
                       // height_inch = (userObj.value(forKey: "height_inch") as? String)!
                    }
                    
                    
                    var achievement = ""
                    
                    if ((userObj.object(forKey: "achievement")) != nil) {
                        if let tempachievement = (userObj.object(forKey: "achievement")) as? String
                        {
                            achievement = tempachievement
                        }
                        else
                        {
                        }
                    }
                    
                    
                    var sport_id = ""
                    
                    if ((userObj.object(forKey: "sport_id")) != nil) {
                        if let tempsport_id = (userObj.object(forKey: "sport_id")) as? String
                        {
                            sport_id = tempsport_id
                        }
                        else
                        {
                        }
                    }
                    
                    
                    var position_id = ""
                    
                    if ((userObj.object(forKey: "position_id")) != nil) {
                        if let tempposition_id = (userObj.object(forKey: "position_id")) as? String
                        {
                            position_id = tempposition_id
                        }
                        else
                        {
                        }
                    }
                    
                    var weight = ""
                    
                    if ((userObj.object(forKey: "weight")) != nil) {
                        if let tempVal = (userObj.object(forKey: "weight")) as? String
                        {
                            weight = tempVal
                        }
                        else
                        {
                        }
                    }
                    
                    
                    var gpa = ""
                    
                    if ((userObj.object(forKey: "gpa")) != nil) {
                        if let tempVal = (userObj.object(forKey: "gpa")) as? String
                        {
                            gpa = tempVal
                        }
                        else
                        {
                        }
                    }
                    
                    var graduating_year = ""
                    
                    if ((userObj.object(forKey: "graduating_year")) != nil) {
                        if let tempVal = (userObj.object(forKey: "graduating_year")) as? String
                        {
                            graduating_year = tempVal
                        }
                        else
                        {
                        }
                    }
                    
                    
                    var committed = ""
                    
                    if ((userObj.object(forKey: "committed")) != nil) {
                        if let tempVal = (userObj.object(forKey: "committed")) as? String
                        {
                            committed = tempVal
                        }
                        else
                        {
                        }
                    }
                    
                    var university = ""
                    
                    if ((userObj.object(forKey: "university")) != nil) {
                        if let tempVal = (userObj.object(forKey: "university")) as? String
                        {
                            university = tempVal
                        }
                        else
                        {
                        }
                    }
                    
                    
                    var teams = ""
                    
                    if ((userObj.object(forKey: "teams")) != nil) {
                        if let tempVal = (userObj.object(forKey: "teams")) as? String
                        {
                            teams = tempVal
                        }
                        else
                        {
                        }
                    }
                    
                    
                    var uni_state = ""
                    
                    if ((userObj.object(forKey: "uni_state")) != nil) {
                        if let tempVal = (userObj.object(forKey: "uni_state")) as? String
                        {
                            uni_state = tempVal
                        }
                        else
                        {
                        }
                    }
                    
                    var user_type = ""
                    
                    if ((userObj.object(forKey: "user_type")) != nil) {
                        if let tempVal = (userObj.object(forKey: "user_type")) as? String
                        {
                            user_type = tempVal
                        }
                        else
                        {
                        }
                    }
                    
                    var position_name = ""
                    
                    if ((userObj.object(forKey: "position_name")) != nil) {
                        if let tempVal = (userObj.object(forKey: "position_name")) as? String
                        {
                            position_name = tempVal
                        }
                        else
                        {
                        }
                    }
                    
                   // print("getUserDetails self.userData " , self.userData)
                    
                    let user = userMVC(userID: userId, first_name: firstName, last_name: lastName, gender: gender, bio: bio, website: website, dob: dob, social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImage, role: "", username: userName, social: "", device_token: "", videoCount: videoCount, likesCount: likesCount, followers: followers, following: followings, followBtn: "",sport_name:sport_name,user_city:user_city,user_state:user_state,height:height,height_inch:height_inch,achievement:achievement , sport_id:sport_id , position_id : position_id , weight:weight,gpa:gpa,graduating_year:graduating_year , committed:committed , university: university,teams: teams , uni_state:uni_state,user_type:user_type,position_name: position_name)
                   
                    self.userData.append(user)
                   // print("getUserDetails user " , self.userData[0])
                    //self.setProfileData()
                    if(user_type == "Youth"){
                        
                        self.showToast(message: "This option is not available for you", font: .systemFont(ofSize: 12))
                    }
                    else{
                        self.getNotifications(startPoint: "\(self.startPoint)")
                    }
                    
                }else{
                    
                    //                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    print("showOwnDetail API:",response?.value(forKey: "msg") as Any)
                }
                
            }else{
                
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showOwnDetail API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
    
}
