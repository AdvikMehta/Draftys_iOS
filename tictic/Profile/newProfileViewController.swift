//
//  newProfileViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 13/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import DropDown
import Lottie

//@available(iOS 13.0, *)
class newProfileViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var myUser: [User]? {didSet {}}
    var userID = ""
    var otherUserID = ""
    
    @IBOutlet weak var topHolderMasterView: UIView!
    
    @IBOutlet weak var innerHolderMasterView: UIView!
    @IBOutlet var scrollViewOutlet: UIScrollView!
    @IBOutlet var whoopsView: UIView!
    
    @IBOutlet var userImageOutlet: [UIImageView]!
    
    @IBOutlet weak var userHeaderName: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var vidContainerView: UIView!
    @IBOutlet weak var likedContainerView: UIView!
    @IBOutlet weak var privateContainerView: UIView!
    
    @IBOutlet weak var profileDropDownBtn: UIButton!
    @IBOutlet weak var btnBackOutlet: UIButton!
    @IBOutlet weak var btnChatOutlet: UIButton!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var btnLive: UIButton!
    
    @IBOutlet weak var extraInfoLbl: UILabel!
    
    @IBOutlet weak var extraValueLbl: UILabel!
    
    @IBOutlet weak var achivementLbl: UILabel!
    //MARK: - DropDown's
    @IBOutlet weak var bottomCollectionHolderView: UIView!
    
    
    let profileDropDown = DropDown()
    
    var videosMainArr = [videoMainMVC]()
    
    var likeVidArr = [videoMainMVC]()
    var privateVidArr = [videoMainMVC]()
    var userVidArr = [videoMainMVC]()
    var userData = [userMVC]()
    
    var privacySettingData = [privacySettingMVC]()
    var pushNotiSettingData = [pushNotiSettingMVC]()
    
    var isOtherUserVisting = false
    
    var storeSelectedIP = IndexPath(item: 0, section: 0)
    
    var userInfo = [["type":"Following","count":"0"],["type":"Followers","count":"0"],["type":"Likes","count":"0"],["type":"Videos","count":"0"]]
    
    
    var userItem = [["Image":"music tok icon-2","ImageSelected":"music tok icon-5","isSelected":"true"],["Image":"likeVideo","ImageSelected":"music tok icon-6","isSelected":"false"],["Image":"music tok icon-1","ImageSelected":"music tok icon-4","isSelected":"false"]]
    
    //MARK:- Outlets
    
    @IBOutlet weak var userInfoCollectionView: UICollectionView!
    @IBOutlet weak var userItemsCollectionView: UICollectionView!
    @IBOutlet weak var videosCV: UICollectionView!
    
    //    @IBOutlet weak var heightOfLikedCVconst: NSLayoutConstraint!
    @IBOutlet weak var uperViewHeightConst: NSLayoutConstraint!
//    var arrImage = [["image":"v1"],["image":"v3"],["image":"v1"],["image":"v3"],["image":"v1"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v3"],["image":"v1"],["image":"v3"]]
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLive.isHidden =  true
        setupDropDowns()
        /*
        let height = videosCV.collectionViewLayout.collectionViewContentSize.height
        uperViewHeightConst.constant = height
        print("height: ",height)
        //        self.heightOfLikedCVconst.constant =  CGFloat(200 * arrImage.count/3)
        self.view.layoutIfNeeded()
        videosCV.reloadData()
         */
        if #available(iOS 10.0, *) {
            scrollViewOutlet.refreshControl = refresher
        } else {
            scrollViewOutlet.addSubview(refresher)
        }
        
       
        
        let image = UIImage(named: "menu_Vertical")?.withRenderingMode(.alwaysTemplate)
        self.profileDropDownBtn.setImage(image, for: .normal)
        self.profileDropDownBtn.tintColor = UIColor.white
        
        
        let image1 = UIImage(named: "messageicon")?.withRenderingMode(.alwaysTemplate)
        self.btnChatOutlet.setImage(image1, for: .normal)
        self.btnChatOutlet.tintColor = UIColor.white
        
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }

    
    @objc
    func requestData() {
        print("requesting data")
//        getVideosData()
//        getSliderData()
        
        for i in 0..<self.userItem.count {
            var obj  = self.userItem[i]
            obj.updateValue("false", forKey: "isSelected")
            self.userItem.remove(at: i)
            self.userItem.insert(obj, at: i)
            
        }

        self.StoreSelectedIndex(index: storeSelectedIP.row)
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    //    MARK:- WILL APPEAR
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.navigationController!.viewControllers.count == 1) {
            NSLog("self is RootViewController");
            
            print("self is RootViewController",self.navigationController!.viewControllers.count)
            
            self.tabBarController?.tabBar.isHidden = false
        }
        
        self.fetchingUserDataFunc()
        
    }
    
    func fetchingUserDataFunc(){
        self.userID = UserDefaults.standard.string(forKey: "userID")!
        //self.otherUserID = UserDefaults.standard.string(forKey: "otherUserID")!
        /*
        if isOtherUserVisting == true{
            UserDefaults.standard.set(otherUserID, forKey: "otherUserID")
            print("otherUsrID: ",otherUserID)
            self.getOtherUserDetails()
            btnChatOutlet.isHidden = false
            btnFollow.isHidden = false
        
        }else{
            UserDefaults.standard.set("", forKey: "otherUserID")
            self.otherUserID = ""
            self.getUserDetails()
            btnChatOutlet.isHidden = true
            btnFollow.isHidden = true
        }
        
        
        */
        
        
        /*
        //        self.userID = UserDefaults.standard.string(forKey: "userID")!
        
        print("otherUid: ",self.otherUserID)
        if self.otherUserID != "" && self.otherUserID != nil {
            self.getOtherUserDetails()
            btnChatOutlet.isHidden = false
            btnFollow.isHidden = false
            btnBackOutlet.isHidden = false
//            self.otherUserID = otherUid!
            getUserVideos()
            //            self.StoreSelectedIndex(index: storeSelectedIP.row)
        }else{
            UserDefaults.standard.set("", forKey: "otherUserID")
            self.getUserDetails()
            btnChatOutlet.isHidden = true
            btnFollow.isHidden = true
            btnBackOutlet.isHidden = true
            self.otherUserID = ""
            //            self.StoreSelectedIndex(index: storeSelectedIP.row)
            getUserVideos()
            
            
            let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressVideo))
            lpgr.minimumPressDuration = 0.5
            lpgr.delegate = self
            lpgr.delaysTouchesBegan = true
            self.videosCV.addGestureRecognizer(lpgr)
        }
        
       */
        
        AppUtility?.startLoader(view: self.view)
        if isOtherUserVisting{
            print("getOtherUserDetails if ")
            self.getOtherUserDetails()
            btnChatOutlet.isHidden = false
            btnFollow.isHidden = true
            btnBackOutlet.isHidden = false
            btnLive.isHidden = true
//            self.otherUserID = otherUid!
            getUserVideos()

        }else{
            print("getUserDetails else ")
            self.getUserDetails()
            btnChatOutlet.isHidden = true
            btnFollow.isHidden = true
            btnBackOutlet.isHidden = true
            btnLive.isHidden = true// false
            self.otherUserID = ""
            //            self.StoreSelectedIndex(index: storeSelectedIP.row)
            getUserVideos()
            
            
            let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressVideo))
            lpgr.minimumPressDuration = 0.5
            lpgr.delegate = self
            lpgr.delaysTouchesBegan = true
            self.videosCV.addGestureRecognizer(lpgr)

        }
        print("videosArr.count: ",videosMainArr.count)
    }

    
    //MARK:- Button Action
    @IBAction func btnChat(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "newChatVC") as! newChatViewController
        vc.receiverData = userData
        vc.otherVisiting = true
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func profileDropDownAction(_ sender: AnyObject) {
        profileDropDown.show()
    }
    
    @IBAction func btnLive(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainViewController

//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.navigationBar.isHidden =  true
        vc.userData = self.userData
//        vc.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(vc, animated: true)
        
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.isHidden =  true
//        KeyCenter.isAudience =  false
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)

    }
    
    //MARK: TableView
    
    //MARK: CollectionView.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView ==  userInfoCollectionView{
            return self.userInfo.count
        }else if collectionView ==  videosCV{
            return videosMainArr.count
        }else{
            return self.userInfo.count
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "newProfileItemsCVC", for:indexPath) as! newProfileItemsCollectionViewCell
        
        if collectionView ==  userInfoCollectionView{
            //cell.backgroundColor = UIColor.red
            cell.lblCount.text =  self.userInfo[indexPath.row]["count"]
            cell.lblCount.textColor = UIColor.white
            cell.typeFollowing.text = self.userInfo[indexPath.row]["type"]
            cell.typeFollowing.textColor =  UIColor(red: 110.0/255.0, green: 252.0/255.0, blue: 241.0/255.0, alpha: 1)
            

            
            if indexPath.row ==  self.userInfo.count - 1 {
                cell.verticalView.isHidden = true
            }
            else
            {
                cell.verticalView.isHidden = false
            }
            
            
        }
        else if collectionView == videosCV{
            let videoObj = videosMainArr[indexPath.row]
//            cell.imgVideoTrimer.sd_setImage(with: URL(string:videoObj.videoGIF), placeholderImage: UIImage(named: "videoPlaceholder"))
            
            let gifURL = AppUtility?.detectURL(ipString: videoObj.videoGIF)
            
            cell.imgVideoTrimer.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgVideoTrimer.sd_setImage(with: URL(string:(gifURL!)), placeholderImage: UIImage(named:"videoPlaceholder"))
            
            cell.lblViewerCount.text(videoObj.view)
        }
        else
        {
            if indexPath.row == 0 {
                if self.userItem[indexPath.row]["isSelected"] == "false"{
                    cell.horizontalView.isHidden  = true
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["Image"]!)
                }else{
                    cell.horizontalView.isHidden  = false
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["ImageSelected"]!)
                }
            }
            if indexPath.row == 1 {
                if self.userItem[indexPath.row]["isSelected"] == "false"{
                    cell.horizontalView.isHidden  = true
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["Image"]!)
                }else{
                    cell.horizontalView.isHidden  = false
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["ImageSelected"]!)
                }
            }
            if indexPath.row == 2{
                if self.userItem[indexPath.row]["isSelected"] == "false"{
                    cell.horizontalView.isHidden  = true
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["Image"]!)
                }else{
                    cell.horizontalView.isHidden  = false
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["ImageSelected"]!)
                }
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == userItemsCollectionView{
            
            for i in 0..<self.userItem.count {
                var obj  = self.userItem[i]
                obj.updateValue("false", forKey: "isSelected")
                self.userItem.remove(at: i)
                self.userItem.insert(obj, at: i)
                
            }
            
            self.StoreSelectedIndex(index: indexPath.row)
            self.storeSelectedIP = indexPath
        }
        else if collectionView == userInfoCollectionView
        {
            print("ip: ",indexPath.row)

            if indexPath.row == 0{
                if userData[0].following == "0"{
                    self.showToast(message: "0 Followers", font: .systemFont(ofSize: 12))
                    return
                }

                let vc = storyboard?.instantiateViewController(withIdentifier: "followingsVC") as! followingsViewController
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 1{
                if userData[0].followers == "0"{
                    self.showToast(message: "0 Followings", font: .systemFont(ofSize: 12))
                    return
                }
                let vc = storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersViewController
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if collectionView == videosCV
        {
            let vc = storyboard?.instantiateViewController(withIdentifier: "homeFeedVC") as! homeFeedViewController
            vc.userVideoArr = videosMainArr
            vc.indexAt = indexPath
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func StoreSelectedIndex(index:Int){
        var obj  =  self.userItem[index]
        obj.updateValue("true", forKey: "isSelected")
        self.userItem.remove(at: index)
        self.userItem.insert(obj, at: index)
        
        if index == 0{
            print("my vid")
            AppUtility?.startLoader(view: self.view)
            getUserVideos()

            
        }else if index == 1{
            print("liked")
            AppUtility?.startLoader(view: self.view)
            getLikedVideos()

            
        }else{
            print("private")
            AppUtility?.startLoader(view: self.view)
            getPrivateVideos()
            
        }
        self.userItemsCollectionView.reloadData()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let index = Int(self.userItemsCollectionView.contentOffset.x) / Int(self.userItemsCollectionView.frame.width)
        
        
        print("index: ",index)
        if index == 0{
            
        }else{
            
        }
        
        let y: CGFloat = scrollView.contentOffset.y
        print(y)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == userInfoCollectionView{
            return CGSize(width: self.userInfoCollectionView.frame.size.width/4, height: 50)
            
        }else if collectionView == userItemsCollectionView{
            return CGSize(width: self.userItemsCollectionView.frame.size.width/3, height: 50)
            
        }else{
            return CGSize(width: self.videosCV.frame.size.width/3-1, height: 204)
        }
    }
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
    
    //MARK: Location
    
    //MARK: Google Maps
    
    //MARK:- View Life Cycle End here...
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBack(_ sender: Any) {
        UserDefaults.standard.set("", forKey: "otherUserID")
        navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("toppppppp")
    }
    
    //MARK:- GET USER OWN DETAILS
    func getUserDetails(){
        self.userData.removeAll()
        
//        AppUtility?.startLoader(view: view)
        ApiHandler.sharedInstance.showOwnDetail(user_id: self.userID) { (isSuccess, response) in
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
                    self.privacySettingData.append(privObj)
                    
                    //                    MARK:- PUSH NOTIFICATION SETTING DATA
                    let cmnt = pushNotiSettingObj.value(forKey: "comments")
                    let direct_messages = pushNotiSettingObj.value(forKey: "direct_messages")
                    let likes = pushNotiSettingObj.value(forKey: "likes")
                    let pushID = pushNotiSettingObj.value(forKey: "id")
                    let new_followers = pushNotiSettingObj.value(forKey: "new_followers")
                    let video_updates = pushNotiSettingObj.value(forKey: "video_updates")
                    let mentions = pushNotiSettingObj.value(forKey: "mentions")
                    
                    let pushObj = pushNotiSettingMVC(comments: "\(cmnt!)", direct_messages: "\(direct_messages!)", likes: "\(likes!)", mentions: "\(mentions!)", new_followers: "\(new_followers!)", video_updates: "\(video_updates!)", id: "\(pushID!)")
                    
                    self.pushNotiSettingData.append(pushObj)
                    
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
                    self.setProfileData()
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
    
    //MARK:- GET other USER DETAILS
    func getOtherUserDetails(){
        self.userData.removeAll()
        
        print("otheruser: ",self.otherUserID)
        print("userID: ",self.userID)
//        AppUtility?.startLoader(view: view)
        ApiHandler.sharedInstance.showOtherUserDetail(user_id: self.userID, other_user_id: self.otherUserID) { (isSuccess, response) in
            
            
            if isSuccess{
                
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userObj = userObjMsg.value(forKey: "User") as! NSDictionary
                    
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
                    let followBtn = (userObj.value(forKey: "button") as? String)!

                    
                    var sport_name = ""
                    
                    if ((userObj.object(forKey: "sport_name")) != nil) {
                        print("response someKey exists")
                       // user_city = (userObj.value(forKey: "user_city") as? String)!
                        
                        if let value = (userObj.object(forKey: "sport_name") as? String)
                        {
                          //NOT NULL
                            sport_name = value
                        }
                        else
                        {
                           //NULL
                        }
                    }
                    
                    
                    let userId = (userObj.value(forKey: "id") as? String)!
                    
                    var user_city = ""
                    
                    if ((userObj.object(forKey: "user_city")) != nil) {
                        print("response someKey exists")
                       // user_city = (userObj.value(forKey: "user_city") as? String)!
                        
                        if let value = (userObj.object(forKey: "user_city") as? String)
                        {
                          //NOT NULL
                            user_city = value
                        }
                        else
                        {
                           //NULL
                        }
                    }
                    
                    var user_state = ""
                    
                    if ((userObj.object(forKey: "user_state")) != nil) {
                        print("response someKey exists")
                       // user_state = (userObj.value(forKey: "user_state") as? String)!
                        
                        if let value = (userObj.object(forKey: "user_state") as? String)
                        {
                          //NOT NULL
                            user_state = value
                        }
                        else
                        {
                           //NULL
                        }
                    }
                    
                    var height = ""
                    //print("Height Check " , userObj.object(forKey: "height"))
                    
                    if ((userObj.object(forKey: "height")) != nil ) {
                        print("response someKey exists")
                       
                        if let value = (userObj.object(forKey: "height") as? String)
                        {
                          //NOT NULL
                            height = value
                        }
                        else
                        {
                           //NULL
                        }
                        
                       
                    }
                    
                    var height_inch = ""
                    
                    if ((userObj.object(forKey: "height_inch")) != nil) {
                        print("response someKey exists")
                      //  height_inch = (userObj.value(forKey: "height_inch") as? String)!
                        
                        if let value = (userObj.object(forKey: "height_inch") as? String)
                        {
                          //NOT NULL
                            height_inch = value
                        }
                        else
                        {
                           //NULL
                        }
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
                                        
                    
                    let user = userMVC(userID: userId, first_name: firstName, last_name: lastName, gender: gender, bio: bio, website: website, dob: dob, social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImage, role: "", username: userName, social: "", device_token: "", videoCount: videoCount, likesCount: likesCount, followers: followers, following: followings, followBtn: followBtn,sport_name:sport_name,user_city:user_city,user_state:user_state,height:height,height_inch:height_inch,achievement:achievement , sport_id:sport_id , position_id : position_id , weight:weight,gpa:gpa,graduating_year:graduating_year , committed:committed , university: university,teams: teams , uni_state:uni_state,user_type: user_type , position_name:position_name)
                    
                    self.userData.append(user)
                    
                    
                    //                    self.getVideos()
                    self.setProfileData()
                }else{
                    
                    //                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    print("showOtherUserDetail API:",response?.value(forKey: "msg") as Any)
                }
                
            }else{
                
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showOtherUserDetail API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
    
    //    MARK:- GET USERS VIDEOS
    func getUserVideos(){
        
        print("userID test: ",userID)
        self.userVidArr.removeAll()
        self.videosMainArr.removeAll()
        
        var uid = ""
        print("otherUserID: ",self.otherUserID)
        if otherUserID != ""{
            uid = self.otherUserID
        }else{
            uid = self.userID
        }
        print("uid: ",uid)
        
        //        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showVideosAgainstUserID(user_id: uid) { (isSuccess, response) in
            AppUtility?.stopLoader(view: self.view)
            if isSuccess{
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userPublicObj = userObjMsg.value(forKey: "public") as! NSArray
                    
                    for i in 0..<userPublicObj.count{
                        let publicObj  = userPublicObj.object(at: i) as! NSDictionary
                        
                        let videoObj = publicObj.value(forKey: "Video") as! NSDictionary
                        let userObj = publicObj.value(forKey: "User") as! NSDictionary
                        let soundObj = publicObj.value(forKey: "Sound") as! NSDictionary
                        
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
                        
                        self.userVidArr.append(video)
                    }
                    
                }else{
                    
                    //  self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                }
                
                self.videosMainArr = self.userVidArr
                if self.videosMainArr.isEmpty == true{
                    self.whoopsView.isHidden = false
                }else{
                    self.whoopsView.isHidden = true
                }
                
                print("videosMainArr.count: ",self.videosMainArr.count)

                self.videosCV.reloadData()
                
                let height = self.videosCV.collectionViewLayout.collectionViewContentSize.height
                self.uperViewHeightConst.constant = height
                print("height: ",height)
                //        self.heightOfLikedCVconst.constant =  CGFloat(200 * arrImage.count/3)
                self.view.layoutIfNeeded()
                self.videosCV.reloadData()
                
            }else{
                
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showVideosAgainstUserID API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
    
    //    MARK:- GET LIKED VIDEOS
    func getLikedVideos(){
        
        
        //        AppUtility?.stopLoader(view: view)
        
        print("userID test: ",userID)
        self.likeVidArr.removeAll()
        self.videosMainArr.removeAll()
        
        var uid = ""
        if otherUserID != ""{
            uid = self.otherUserID
        }else{
            uid = self.userID
        }
        
        //        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showUserLikedVideos(user_id: uid) { (isSuccess, response) in
            AppUtility?.stopLoader(view: self.view)
            if isSuccess{
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let likeObjMsg = response?.value(forKey: "msg") as! NSArray
                    //                    let userPublicObj = userObjMsg.value(forKey: "public") as! NSArray
                    
                    for i in 0..<likeObjMsg.count{
                        let likeObj  = likeObjMsg.object(at: i) as! NSDictionary
                        
                        let videoObj = likeObj.value(forKey: "Video") as! NSDictionary
                        
                        //                        let soundObj = videoObj.value(forKey: "Sound") as! NSDictionary
                        let userObj = videoObj.value(forKey: "User") as! NSDictionary
                        
                        
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
                        let verified = userObj.value(forKey: "verified")
                        //                        let followBtn = userObj.value(forKey: "button") as! String
                        
                        //                        let soundID = soundObj.value(forKey: "id") as? String
                        //                        let soundName = soundObj.value(forKey: "name") as? String
                        
                        let video = videoMainMVC(videoID: videoID, videoUserID: "", fb_id: "", description: videoDesc, videoURL: videoUrl, videoTHUM: videoThum, videoGIF: videoGif, view: views, section: "", sound_id: "", privacy_type: "", allow_comments: allowComment, allow_duet: allowDuet, block: "", duet_video_id: "", old_video_id: "", created: created, like: like, favourite: "", comment_count: videoComments, like_count: videoLikes, followBtn: "", duetVideoID: "\(duetVidID!)", userID: userID, first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImg, role: "", username: username, social: "", device_token: "", videoCount: "", verified: "\(verified ?? "")", soundName:  "")
                        
                        self.likeVidArr.append(video)
                    }
                    
                }else{
                    
                    //  self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                }
                self.videosMainArr = self.likeVidArr
                if self.videosMainArr.isEmpty == true{
                    self.whoopsView.isHidden = false
                }else{
                    self.whoopsView.isHidden = true
                }
                self.videosCV.reloadData()
                let height = self.videosCV.collectionViewLayout.collectionViewContentSize.height
                self.uperViewHeightConst.constant = height
                print("height: ",height)
                //        self.heightOfLikedCVconst.constant =  CGFloat(200 * arrImage.count/3)
                self.view.layoutIfNeeded()
                self.videosCV.reloadData()
                
            }else{
                
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showVideosAgainstUserID API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
    
    //    MARK:- GET PRIVATE VIDEOS
    func getPrivateVideos(){
                
        print("userID test: ",userID)
        self.likeVidArr.removeAll()
        self.videosMainArr.removeAll()
        
        var uid = ""
        if otherUserID != ""{
            uid = self.otherUserID
        }else{
            uid = self.userID
        }
        
        ApiHandler.sharedInstance.showVideosAgainstUserID(user_id: uid) { (isSuccess, response) in
            AppUtility?.stopLoader(view: self.view)
            if isSuccess{
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userPrivateObj = userObjMsg.value(forKey: "private") as! NSArray
                    
                    for i in 0..<userPrivateObj.count{
                        let privateObj  = userPrivateObj.object(at: i) as! NSDictionary
                        
                        let videoObj = privateObj.value(forKey: "Video") as! NSDictionary
                        let userObj = privateObj.value(forKey: "User") as! NSDictionary
                        let soundObj = privateObj.value(forKey: "Sound") as! NSDictionary
                        
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
                        
                        self.privateVidArr.append(video)
                    }
                    
                }else{
                    
                    //  self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                }
                
                self.videosMainArr = self.privateVidArr
                if self.videosMainArr.isEmpty == true{
                    self.whoopsView.isHidden = false
                }else{
                    self.whoopsView.isHidden = true
                }
                self.videosCV.reloadData()

                let height = self.videosCV.collectionViewLayout.collectionViewContentSize.height
                self.uperViewHeightConst.constant = height
                print("height: ",height)
                self.view.layoutIfNeeded()
                self.videosCV.reloadData()
                
            }else{
                
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showVideosAgainstUserID API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
    func setProfileData(){
        
        let user = userData[0]
//        let user = userData[0]
        self.userInfo = [["type":"Following","count":user.following],["type":"Followers","count":user.followers],["type":"Likes","count":user.likesCount],["type":"Videos","count":"\(user.videoCount)"]]
        userInfoCollectionView.reloadData()
        
        let profilePic = AppUtility?.detectURL(ipString: user.userProfile_pic)
        
        self.userName.text = "@\(user.username)"
        self.userHeaderName.text = user.first_name+" "+user.last_name
        for img in userImageOutlet{
            img.sd_imageIndicator = SDWebImageActivityIndicator.gray
            img.sd_setImage(with: URL(string:profilePic!), placeholderImage: UIImage(named: "noUserImg"))
        }
        
        var extraInfoStr = ""
        
        
        
        if(user.sport_name.count > 0){
            extraInfoStr = extraInfoStr + " "  + user.sport_name
            
            if(user.position_id != ""){
                extraInfoStr =  extraInfoStr + " / "  + user.position_name + " \n"
            }
            else{
                extraInfoStr = extraInfoStr + " \n"
            }
        }
        
        if(user.user_type == "Athlete"){
            if(user.graduating_year.count > 0){
                extraInfoStr = extraInfoStr + " " + " CO " + user.graduating_year + " /"
            }
            
            if(user.gpa.count > 0){
                extraInfoStr =  extraInfoStr + " " + user.gpa + " GPA " + " /"
            }
            
            if(user.weight.count > 0){
                extraInfoStr =  extraInfoStr + " " + user.weight + " lbs /"
            }
            
            if(user.height.count > 0){
                extraInfoStr =  extraInfoStr + " " + user.height + "'" + user.height_inch + " \n"
            }
            
            if(user.user_city.count > 0){
                extraInfoStr =  extraInfoStr + " " + user.user_city + " /"
            }
            
            if(user.user_state.count > 0){
                extraInfoStr =  extraInfoStr + " " + user.user_state + " /"
            }
            
            if(user.committed.count > 0){
                var commitedValStr = ""
                
                if(user.committed == "Y"){
                    commitedValStr = "Committed"
                }
                else{
                    commitedValStr = "Uncommitted"
                }
                extraInfoStr =  extraInfoStr + " " + commitedValStr
            }
            
        }
        else if(user.user_type == "Coach/Scout/Talent Acquisition"){
            if(user.user_city.count > 0){
                extraInfoStr =  extraInfoStr + " " + user.user_city + " /"
            }
            
            if(user.user_state.count > 0){
                extraInfoStr =  extraInfoStr + " " + user.user_state + " /"
            }
            
            if(user.university.count > 0){
                extraInfoStr =  extraInfoStr + " " + user.university + " /"
            }
            
            if(user.teams.count > 0){
                extraInfoStr =  extraInfoStr + " " + user.teams + " /"
            }
        }
        
        print("extraInfoStr " , extraInfoStr)
        
        if(extraInfoStr.count > 0){
         
            let lastChar = extraInfoStr.last!

            if(String(lastChar) == "/"){
                print("/ detected , remove it")
                extraInfoStr = String(extraInfoStr.dropLast())
            }
            
        }
        

        
        
        
        
         //user.bio
        self.extraInfoLbl.text = extraInfoStr
        let extraInfoHt = self.heightForView(text: extraInfoStr, font: self.extraInfoLbl.font, width: self.extraInfoLbl.frame.size.width)
        
        
       // self.extraInfoLbl.frame.size.height = extraInfoHt
        self.extraInfoLbl.frame = CGRect(x: self.extraInfoLbl.frame.origin.x, y: self.extraInfoLbl.frame.origin.y, width: self.extraInfoLbl.frame.size.width, height: extraInfoHt)
       // self.extraInfoLbl.backgroundColor = UIColor.red
        
      //
        
        self.achivementLbl.text = user.achievement
        
        self.achivementLbl.frame.origin.y = self.extraInfoLbl.frame.size.height + self.extraInfoLbl.frame.origin.y+5
        
        self.extraValueLbl.frame.origin.y = self.achivementLbl.frame.size.height + self.achivementLbl.frame.origin.y+5
        
        self.extraValueLbl.text = user.bio
        
        let bioHt = self.heightForView(text: self.extraValueLbl.text!, font: self.extraValueLbl.font, width: self.extraValueLbl.frame.size.width)
        
        self.extraValueLbl.frame.size.height = bioHt
        
        self.innerHolderMasterView.frame.size.height = self.extraValueLbl.frame.size.height + self.extraValueLbl.frame.origin.y + 20
        
        self.topHolderMasterView.frame.size.height = self.innerHolderMasterView.frame.size.height + self.innerHolderMasterView.frame.origin.y
        
        
        self.userItemsCollectionView.frame.origin.y = self.topHolderMasterView.frame.size.height + self.topHolderMasterView.frame.origin.y + 10
        
        self.bottomCollectionHolderView.frame.origin.y = self.topHolderMasterView.frame.size.height + self.topHolderMasterView.frame.origin.y + 45
        
        self.bottomCollectionHolderView.frame.size.height = self.view.frame.size.height -
            (self.topHolderMasterView.frame.size.height + self.topHolderMasterView.frame.origin.y + 45)
        
       // self.bottomCollectionHolderView.alpha = 0.0
       // self.userItemsCollectionView.alpha = 0.0
    }
    
    func setupDropDowns(){
        profileDropDown.width = 150
        profileDropDown.anchorView = profileDropDownBtn
        profileDropDown.backgroundColor = .white
        profileDropDown.bottomOffset = CGPoint(x: 0, y: profileDropDownBtn.bounds.height)
        
        if isOtherUserVisting == true{
            btnBackOutlet.isHidden = false
            profileDropDown.dataSource = [
                "Report",
                "Block"
            ]
        }else{
            btnBackOutlet.isHidden = true
            profileDropDown.dataSource = [
              "Edit Profile",
                "Favourite",
                "Setting",
                "Logout"
            ]
        }
        
        // Action triggered on selection
        profileDropDown.selectionAction = { [weak self] (index, item) in
            
            switch item {
            case "Report":
                print("selected item: ",item)
                
                let alertController = UIAlertController(title: "REPORT", message: "Enter the details of Report", preferredStyle: .alert)
                
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "Report Title"
                }
                
                let reportAction = UIAlertAction(title: "Report", style: .default, handler: { alert -> Void in
                    let firstTextField = alertController.textFields![0] as UITextField
                    let secondTextField = alertController.textFields![1] as UITextField
                    
                    print("fst txt: ",firstTextField)
                    print("scnd txt: ",secondTextField.text)
                    
                    guard let text = secondTextField.text, !text.isEmpty else {
                        self?.showToast(message: "Fill All Fields", font: .systemFont(ofSize: 12))
                        return
                    }
                    self!.reportUser(reportReason: text)
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil )
                
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "Reason"
                }
                
                alertController.addAction(cancelAction)
                alertController.addAction(reportAction)
                
                self!.present(alertController, animated: true, completion: nil)
                
                
            case "Block":
                print("selected item: ",item)
                self!.blockUser()
                
            case "Edit Profile":
                print("selected item: ",item)
                print("edit profile userdata " , self!.userData[0])
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "editProfileVC") as! editProfileViewController
                vc.userData = self!.userData
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            case "Favourite":
                print("selected item: ",item)
                
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "favMainVC") as! favMainViewController
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            case "Setting":
                print("selected item: ",item)
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "privacyAndSettingVC") as! privacyAndSettingViewController
//                  vc.userData = self!.userData
                  vc.hidesBottomBarWhenPushed = true
                  self?.navigationController?.pushViewController(vc, animated: true)
            case "Logout":
                print("select item: ",item)
                
                self?.tabBarController?.selectedIndex = 0

                self?.tabBarController?.tabBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self?.tabBarController?.tabBar.unselectedItemTintColor = UIColor.white
                var myUser: [User]? {didSet {}}
                myUser = User.readUserFromArchive()
                myUser?.removeAll()
                self!.logoutUserApi()
                
            default:
                print("select item: ",item)
            }
        }
    }
    
    func blockUser(){
        AppUtility?.startLoader(view: self.view)
        let uid = UserDefaults.standard.string(forKey: "userID")
        let otherUid = UserDefaults.standard.string(forKey: "otherUserID")
        
        print("block uid: \(uid) blockUid: \(otherUid)")
        ApiHandler.sharedInstance.blockUser(user_id: uid!, block_user_id: otherUid!) { (isSuccess, response) in
            AppUtility?.stopLoader(view: self.view)
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    self.showToast(message: "Blocked", font: .systemFont(ofSize: 12))
                    self.navigationController?.popToRootViewController(animated: true)
                    
                }else{
                    
                    //                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    print("blockUser API:",response?.value(forKey: "msg") as! String)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            
        }
        
    }
    func logoutUserApi(){
        
        let userID = UserDefaults.standard.string(forKey: "userID")
        print("user id: ",userID as Any)
        AppUtility?.startLoader(view: view)
        ApiHandler.sharedInstance.logout(user_id: userID! ) { (isSuccess, response) in
            AppUtility?.stopLoader(view: self.view)
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    //  self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
                    print(response?.value(forKey: "msg") as Any)
                    UserDefaults.standard.set("", forKey: "savedRegPhnNo")
                    UserDefaults.standard.set("", forKey: "userID")
                }else{
                    //                    self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
                    print("logout API:",response?.value(forKey: "msg") as! String)
                }
            }else{
                
                //                self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
                print("logout API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
    
    //    MARK:- Report user func
    func reportUser(reportReason: String){
        AppUtility?.startLoader(view: self.view)
        
        print("report user id: \(otherUserID) userID: \(UserDefaults.standard.string(forKey: "userID")!)")
        
        ApiHandler.sharedInstance.reportUser(user_id: UserDefaults.standard.string(forKey: "userID")!, report_user_id: otherUserID, report_reason_id: "1", description: reportReason) { (isSuccess, response) in
            AppUtility?.stopLoader(view: self.view)
            if isSuccess{
                
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    self.showToast(message: "Report Under Review", font: .systemFont(ofSize: 12))
                }else{
                    
                    //                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    print("reportUser API:",response?.value(forKey: "msg") as Any)
                }
            }else{
                print("reportUser API:",response?.value(forKey: "msg") as Any)
                
            }
        }
    }
    func alertModule(title:String,msg:String){
        
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
//    MARK:- handleLongPressVideo
    @objc func handleLongPressVideo(gestureReconizer: UILongPressGestureRecognizer) {
        
        print("longPressed")
//        func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
            
//            if (gestureReconizer.state != UIGestureRecognizer.State.ended){
//                return
//            }
            
            let p = gestureReconizer.location(in: self.videosCV)
            
            if let indexPath : IndexPath = (self.videosCV?.indexPathForItem(at: p)) as IndexPath?{
                //do whatever you need to do
                
                let alert = UIAlertController(title: "Delete Video", message: "Are you sure you want to delete the item ? ", preferredStyle: .alert)

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                    
                    self.deleteVideoAPI(indexPath: indexPath)
                }

                //Add the actions to the alert controller
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)

                //Present the alert controller
                present(alert, animated: true, completion: nil)
            }
            
//        }
    }
    
//     MARK:- DELETE VIDEO FUNC
    func deleteVideoAPI(indexPath:IndexPath){
        
        let videoID = videosMainArr[indexPath.row].videoID
        AppUtility?.startLoader(view: self.view)
        
        ApiHandler.sharedInstance.deleteVideo(video_id: videoID) { (isSuccess, response) in
            
            AppUtility?.stopLoader(view: self.view)
            if isSuccess{
                let code = response?.value(forKey: "code") as! NSNumber
                if code == 200{
                    DispatchQueue.main.async {
//                        self.namesArray.remove(at: indexPath.row)
//                        self.imagesArray.remove(at: indexPath.row)
//                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        
                        self.videosMainArr.remove(at: indexPath.row)
                        self.videosCV.deleteItems(at: [indexPath])
                    }

                }else{
                    AppUtility?.displayAlert(title: "Try Again", message: "Something went Wrong")
                }
            }
        }
    }
}
