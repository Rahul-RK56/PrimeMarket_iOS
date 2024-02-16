//
//  HomeCustomerViewController.swift
//  SMarket
//
//  Created by Mac-00014 on 18/06/18.
//  Copyright © 2018 Mind. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import SafariServices
import WebKit


@available(iOS 11.0, *)
class HomeCustomerViewController: ParentViewController {
    
    @IBOutlet weak var btnSearch : UIButton!
    @IBOutlet weak var vWTitleView : UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtSearch : UITextField!
    @IBOutlet weak var lblRefCase: UILabel!
    @IBOutlet weak var lblReferralAlerts: UILabel!
    @IBOutlet weak var lblAwaitingRewards: UILabel!
    @IBOutlet weak var lblStoreCredit: UILabel!
    @IBOutlet weak var cnSearchWidth : NSLayoutConstraint!
    @IBOutlet weak var lblFriends: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var viewBorder: UIView!
    @IBOutlet weak var btnViewMerchant : UIButton!
    @IBOutlet weak var slideshow: ImageSlideshow!
   
    
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    //@IBOutlet var btnNext: underLineButton!
    var isShowMer = false
    var arrBanner = [Any]()
    var page = 1
    var apiTask : URLSessionTask?
    var viewInvite = UIView()
    var merID = ""
    var merName = ""
  
     
    
  
    //MARK:-
    //MARK:- LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        btnViewMerchant.isHidden = true
        showViewMerchantPopup()
        NotificationCenter.default.addObserver(self, selector: #selector(showViewMerchantPopup), name: Notification.Name("NotifyCloseRefer"), object: nil)
        if isLogin{
            showViewMerchantPopup()
        }
      //  perform(#selector(authenticate), with: nil, afterDelay: 150)
    }
    @objc func authenticate(){
       DispatchQueue.main.async {
           self.presentAlertViewWithTwoButtons(alertTitle: "", alertMessage: CMessageLogout, btnOneTitle: CBtnYes, btnOneTapped: { (action) in
               CUserDefaults.set(appDelegate?.loginUser?.mobile, forKey: UserDefaultCustomerLoginMobile)
               CUserDefaults.set(appDelegate?.loginUser?.country_code, forKey: UserDefaultCustomerLoginPostalCode)
               appDelegate?.signOutCustomerUser(response: nil)
           }, btnTwoTitle: CBtnNo) { (action) in}
       }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    override func viewWillDisappear(_ animated: Bool) {
//        if let refVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "ReferralViewController") as? ReferralViewController {
//            refVC.remove()
//            viewInvite.removeFromSuperview()
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      //  lblRefCase.text = "\(appDelegate!.currency)\(appDelegate?.loginUser?.refcash ?? "0")"
        lblReferralAlerts.text = appDelegate?.loginUser?.refferal_alert
        lblAwaitingRewards.text = appDelegate?.loginUser?.awaiting_rewards
        let val = CUserDefaults.string(forKey: UserDefaultCountryCode)
        if val == "+91"{
            lblStoreCredit.text = "\(appDelegate!.currencyINDIA)\(appDelegate?.loginUser?.store_credit ?? "0")"
            lblRefCase.text = "\(appDelegate!.currencyINDIA)\(appDelegate?.loginUser?.refcash ?? "0")"
        }else{
            //lblStoreCredit.text = "\(appDelegate!.currency)\(appDelegate?.loginUser?.store_credit ?? "0")"
            lblStoreCredit.text = "\(appDelegate!.currencyUSA)\(appDelegate?.loginUser?.store_credit ?? "0")"
            lblRefCase.text = "\(appDelegate!.currencyUSA)\(appDelegate?.loginUser?.refcash ?? "0")"
        }
        
        
    }
    // MARK:-
    // MARK:- GENERAL METHODS
    fileprivate func initialize()  {
        
        self.title = "Smarket"
        
        loadPageControl()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(btnSearchClicked))
        txtSearch.delegate = self
        self.navigationItem.titleView = vWTitleView
        view.backgroundColor = ColorCustomerAppTheme
        cnSearchWidth.constant = CScreenWidth - 140
        
        //.. refreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .gray
       // tblView?.pullToRefreshControl = refreshControl
        view.backgroundColor = ColorCustomerAppTheme
       // view.backgroundColor = UIColor.wh
        loadBannerFromServer()
        getRefered()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(logoImagetapped))
        logoImgView.addGestureRecognizer(tap)
        logoImgView.isUserInteractionEnabled = true
        addImageView(name: "processed")
    }
    
    func  addImageView(name:String)  {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: slideshow.frame.width + 20 , height: 330.67))
        //imgView.backgroundColor = .gray
        imgView.image = UIImage(named: name)
       // imgView.contentMode = .scaleAspectFit
        slideshow.scrollView.addSubview(imgView)
    }
    
    @objc func logoImagetapped() {
        self.showvideo()
    }
    
    func showvideo() {
        if let url = URL(string: "https://youtu.be/4VM4d5kBsXk") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    func checkMerchant(){
        if ((appDelegate?.userDetail) != nil) {
            if appDelegate?.userDetail.valueForString(key: "refered_person") == "merchant"{
                let ref = (appDelegate?.userDetail.valueForJSON(key:"refered_by") as! [String : Any])
                merID = ref.valueForString(key: "id")
                merName = appDelegate?.userDetail.valueForString(key:"refered_business_name") ?? ""
                merName = merName.uppercased()
                isShowMer = true
                //                btnViewMerchant.isHidden = false
            }else{
                //                btnViewMerchant.isHidden = true
                isShowMer = false
            }
        }else{
            //            btnViewMerchant.isHidden = true
            isShowMer = false
        }
    }
    
    @IBAction func leftArrowHandler(sender:UIButton){
        slideshow.setCurrentPage(slideshow.currentPage - 1, animated: true)
    }
    @IBAction func rightArrowHandler(sender:UIButton){
        slideshow.setCurrentPage(slideshow.currentPage + 1, animated: true)
    }
    
    @IBAction func skipButtonHandler(sender:UIButton){
     //  viewBorder.isHidden = true
     //   tblView.isHidden = false
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        if slideshow.currentPage == 0{
            let vc = UIStoryboard(name: "MainCustomer", bundle: nil).instantiateViewController(withIdentifier: "ImageSliderPopUpVC") as! ImageSliderPopUpVC
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    func loadPageControl(){
        
        let localSource = [BundleImageSource(imageString: "processed")]
     //   let localSource = [BundleImageSource(imageString: "FindMerchant"), BundleImageSource(imageString: "SmarketShopping"), BundleImageSource(imageString: "RedeemOfferCode")]
        //        slideshow.slideshowInterval = 3.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        slideshow.addGestureRecognizer(tap)
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = ColorCustomerAppTheme
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        slideshow.pageIndicator = pageControl
        slideshow.pageIndicator?.view.isHidden = true
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        slideshow.setImageInputs(localSource)
        // Do any additional setup after loading the view.
    }
    func getRefered(){
        
        let param = ["user_id": appDelegate?.loginUser?.user_id]
        
        APIRequest.shared().customerReferred(param as [String : Any]) { (response, error) in
            
            if let json = response as? [String : Any], let data = json[CJsonData] as? [String : Any] {
                
                if let refer = data.valueForJSON(key: "refered"){
                    appDelegate?.referred = "\((refer as AnyObject).count ?? 0)"
                    self.lblFriends.text =  appDelegate?.referred
                }
            }
        }
        func showViewMerchantPopup(){
            isLogin = false
            checkMerchant()
            if isShowMer {
                let mainString = "Your refer by \(merName)\n Go to the merchant offer"
                let stringToColor = merName
                let range = (mainString as NSString).range(of: stringToColor)
                let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
                mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemPink, range: range)
                 print(mutableAttributedString)
                
                presentPopUp(title: mutableAttributedString,done: "Ok",cancel: "Cancel") {}
                SkyPopUp.shared?.doneBtnClosure = { [self] in
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                        if let detailVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "MerchantDetailsViewController") as? MerchantDetailsViewController {
                            detailVC.iObject = self.merID
                            self.navigationController?.pushViewController(detailVC, animated: true)
                        }
                    }
                }
            }
        }
    }
    // MARK:-
    // MARK:- ACTION EVENT
    @IBAction func friendsOnSmarketButtonHandler(sender:UIButton){
        if let resetVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "FreindsOnMarketVC") as? FreindsOnMarketVC {
            self.navigationController?.pushViewController(resetVC, animated: true)
        }
    }
    @IBAction func btnSearchClicked(_ sender : UIBarButtonItem) {
      
        
        if let searchVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "MerchantSearchViewController") as? MerchantSearchViewController {
            searchVC.searchText = txtSearch.text!
            searchVC.viewTag = 301
            self.navigationController?.pushViewController(searchVC, animated: false)
            txtSearch.text = ""
        }
        
        //        if let url = URL(string: redirectURL) {
        //            UIApplication.shared.open(url)
        //        }
        
        //                if let url = URL(string: "http://smarketdeals.com/") {
        //                    let config = SFSafariViewController.Configuration()
        //                    config.entersReaderIfAvailable = true
        //
        //                    let vc = SFSafariViewController(url: url, configuration: config)
        //                    vc.delegate = self
        //                    present(vc, animated: true)
        //                }
        
    }
    @IBAction func btnRefCaseClicked(_ sender: UIButton) {
        if let refCashVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "RefcashViewController") as? RefcashViewController {
            refCashVC.view.tag = 300
            self.navigationController?.pushViewController(refCashVC, animated: true)
        }
    }
    @IBAction func btnReferralAlertsClicked(_ sender: UIButton) {
        if let referralAlertsVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "ReferralAlertsViewController") as? ReferralAlertsViewController {
            referralAlertsVC.view.tag = 300
            self.navigationController?.pushViewController(referralAlertsVC, animated: true)
        }
    }
    @IBAction func btnAwaitingClicked(_ sender: UIButton) {
        if let rewardsVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "RewardsViewController") as? RewardsViewController {
            rewardsVC.view.tag = 300
            self.navigationController?.pushViewController(rewardsVC, animated: true)
        }
    }
    @IBAction func btnStoreCreditClicked(_ sender: UIButton) {
        if let storeCreditVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "StoreCreditViewController") as? StoreCreditViewController {
            storeCreditVC.view.tag = 300
            self.navigationController?.pushViewController(storeCreditVC, animated: true)
        }
    }
    @IBAction fileprivate func btnScanClicked(_ sender : UIButton) {
        
        if let scanQRCodeVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "ScanQRCodeViewController") as? ScanQRCodeViewController {
            self.navigationController?.pushViewController(scanQRCodeVC, animated: true)
        }
    }
    @IBAction fileprivate func btnClearSearchBoxClicked(_ sender : UIButton){
        txtSearch.text = ""
    }
    
    @IBAction  func btnMerchantClicked(_ sender : UIButton) {
        
        if let detailVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "MerchantDetailsViewController") as? MerchantDetailsViewController {
            detailVC.iObject = merID
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    @objc func showViewMerchantPopup(){
        isLogin = false
        checkMerchant()
        if isShowMer {
            let mainString = "Your refer by \(merName)\n Go to the merchant offer"
            let stringToColor = merName
            let range = (mainString as NSString).range(of: stringToColor)
            let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
            mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemPink, range: range)
             print(mutableAttributedString)
            
            presentPopUp(title: mutableAttributedString,done: "Ok",cancel: "Cancel") {}
            SkyPopUp.shared?.doneBtnClosure = { [self] in
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    if let detailVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "MerchantDetailsViewController") as? MerchantDetailsViewController {
                        detailVC.iObject = self.merID
                        self.navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
            }
        }
    }
}

// MARK:-
// MARK:- Server request

extension HomeCustomerViewController {
    
    @objc func pullToRefresh()  {
        
        page = 1
        loadBannerFromServer()
    }
    
    fileprivate func loadBannerFromServer() {
        
        if apiTask != nil && apiTask?.state == .running {
            apiTask?.cancel()
        }
        
        let param = ["user_type": CCustomerType,
                     "page": page] as [String : Any]
        
        //        if page == 1 && arrBanner.count == 0 {
        //            tblView.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
        //        }
        
        apiTask =  APIRequest.shared().loadBanner(param) { (response, error) in
          //  self.tblView.pullToRefreshControl?.endRefreshing()
            
            if APIRequest.shared().isJSONStatusValid(withResponse: response) {
                
                if self.page == 1 {
                    self.arrBanner.removeAll()
                   // self.tblView.reloadData()
                }
                
                if let dataResponse = response as? [String : Any], let data = dataResponse[CJsonData] as? [[String: Any]], data.count > 0 {
                    
                   
                    
                    
                    
                    if let meta = dataResponse[CJsonMeta] as? [String: Any] {
                        
                      //  appDelegate?.currency = data["country_code"]
                      
                        appDelegate?.loginUser?.refcash = meta.valueForString(key: "refcash")
                        appDelegate?.loginUser?.refferal_alert = meta.valueForString(key: "refferal_alert")
                        appDelegate?.loginUser?.awaiting_rewards = meta.valueForString(key: "awaiting_rewards")
                        appDelegate?.loginUser?.store_credit = meta.valueForString(key: "store_credit")
                    }
                    
                    self.arrBanner = self.arrBanner + data
                   // print(self.arrBanner)
                    self.page = self.page + 1
                  //  self.tblView.reloadData()
                }
                else {
                    self.page = 0
                }
                
            }
          
             //For remove loader or display data not found
//             if self.arrBanner.count > 0 {
//             self.tblView.stopLoadingAnimation()
//
//             } else if error == nil {
//             self.tblView.showDataStatusView(status: .noResultFound, tintColor: .gray, backgroundColor: .clear, tapToRetry: nil)
//
//             } else if let error = error as NSError? {
//
//             // ... -999 cancelled api
//             // ... --1001 or -1009 no internet connection
//
//             if error.code != -999 {
//
//             self.tblView.showDataStatusView(status: (error.code == -1001 || error.code == -1009) ? .noInternet : .other, tintColor: .gray, backgroundColor: .clear, tapToRetry: {
//
//             self.pullToRefresh()
//
//             })
//             }
           //  }
        }
    }
}


// MARK:-
// MARK:- UITableViewDelegate, UITableViewDataSource

//extension HomeCustomerViewController : UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrBanner.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeOfferTableViewCell") as! HomeOfferTableViewCell
//        
//        if let dict = arrBanner[indexPath.row] as? [String : Any] {
//            cell.imgView.imageWithUrl(dict.valueForString(key: "banner"))
//            
//            cell.imgView.touchUpInside { (imageView) in
//                self.fullScreenImage(imageView, urlString: dict.valueForString(key: "banner"))
//            }
//        }
//        
//        if indexPath.row == arrBanner.count - 1 && page != 0 {
//            loadBannerFromServer()
//        }
//        
//        return cell
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 188
//    }
//    
//}
extension HomeCustomerViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //textField code
        
        txtSearch.resignFirstResponder()  //if desired
        self.btnSearchClicked(UIBarButtonItem())
        return true
    }
}
extension HomeCustomerViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        if page == 0{
          //  btnLeft.isHidden = true
           // btnRight.isHidden = false
            self.lblTitle.text = "Find a merchant"
            
        }
        else if page == 1 {
          //  btnLeft.isHidden = false
          //  btnRight.isHidden = false
            self.lblTitle.text = "Refer merchant"
        }
        else{
          //  btnLeft.isHidden = false
          //  btnRight.isHidden = true
            self.lblTitle.text = "Redeem offer code"
        }
    }
}
class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
extension HomeCustomerViewController : SFSafariViewControllerDelegate{
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        print("finish")
    }
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print("initial load")
    }
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        print(URL)
    }
}



    
