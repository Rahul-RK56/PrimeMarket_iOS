//
//  FreindsOnMarketVC.swift
//  SMarket
//
//  Created by CIPL0668 on 11/09/20.
//  Copyright © 2020 Mind. All rights reserved.
//

import UIKit
import  MapKit
import SafariServices
import SDWebImage
class FriendsOnSmarketCell: UITableViewCell {
    
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblPhone : UILabel!
    @IBOutlet weak var lblEarns: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
class FreindsOnMarketVC: ParentViewController, UISearchResultsUpdating {
    @IBOutlet weak var tableRefered: UITableView!
    
    let formatter = NumberFormatter()
    
    var arrRefered  = [[String:Any]]()
     var baseCouponArray = [[String:Any]]()
    var arrayOfQRCodeData = [[String:Any]]()
    var titleLabel:UILabel?
     let searchController = UISearchController(searchResultsController: nil)
    fileprivate let application = UIApplication.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController?.searchBar.delegate = self
        self.definesPresentationContext = true
        initialize()
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 20))
              
        titleLabel?.textColor = .white
        titleLabel?.textAlignment = .center
       
       
    }
    
    fileprivate func initialize()  {
        self.title = "COUPON OFFER"
       getRefered()
        if let viewController = self.navigationController?.viewControllers {
            
            if !viewController.contains(where: { return $0 is MerchantSearchViewController }) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(btnSearchClicked))
            }
        }else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(btnSearchClicked))
        }
        if let country = CUserDefaults.value(forKey: UserDefaultCountryCode) {
                   if  country as! String == "+91" {
                       appDelegate!.currency = currencyUnitRs
                   }else{
                       appDelegate!.currency = currencyUnit
                   }
               }
               else{
                   appDelegate?.currency = currencyUnit
               }
        
    }
    @objc fileprivate func btnSearchClicked(_ sender : UIBarButtonItem) {
        self.searchController.searchBar.layer.cornerRadius = self.searchController.searchBar.bounds.height/1.5
              self.searchController.searchBar.clipsToBounds = true
               searchController.searchBar.isHidden = false
              self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.titleView = searchController.searchBar
              if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                  searchController.searchBar.tintColor = .black
                  textfield.backgroundColor = UIColor.white
                  textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "Search anting on SMARKET", attributes: [NSAttributedStringKey.foregroundColor : UIColor.lightGray])
                  textfield.placeholder = "Search anything on SMARKET"
                  textfield.textColor = UIColor.black
                 
                  UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.white
              }
            searchController.hidesNavigationBarDuringPresentation = false
            
    //        if let searchVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "MerchantSearchViewController") as? MerchantSearchViewController {
    //            self.navigationController?.pushViewController(searchVC, animated: true)
    //        }
        }
        func updateSearchResults(for searchController: UISearchController) {
            let searchtext = searchController.searchBar.text
              
    //        if arrayAlert.contains(searchtext!) {
    //            print(searchtext)
    //        } else {
    //            print("search text not available!")
    //        }
        }
}

extension FreindsOnMarketVC : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        arrRefered.removeAll()
        if searchText == "" || searchText.count == 0 {
           arrRefered = baseCouponArray
            self.tableRefered.stopLoadingAnimation()
        }else {
            
          for data in baseCouponArray {
                    let tempData = data as? [String : Any]
                        let merchantDctList = tempData?["merchant"] as! [[String:Any]]
                        if merchantDctList.count > 0 {
                           let merchantDct = merchantDctList[0]
                            var searchStr =  merchantDct.valueForString(key: "business_name") as! String
                             var taglineStr =  merchantDct.valueForString(key: "tagline") as! String
                             
                            if searchStr.lowercased().contains(searchText.lowercased())  || taglineStr.lowercased().contains(searchText.lowercased()){
                                arrRefered.append(data)
                            }
                        }
                     
                       
                   }
               }
       
      tableRefered.reloadData()
        if arrRefered.count == 0 {
            self.tableRefered.showDataStatusView(status: .noResultFound, tintColor: .gray, backgroundColor: .clear, tapToRetry: nil)
    }
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      self.tableRefered.stopLoadingAnimation()
      self.arrRefered = self.baseCouponArray
      self.tableRefered.reloadData()
      
      
      searchController.searchBar.isHidden = true
      
      titleLabel?.text = "COUPON OFFER"
       self.navigationItem.titleView = titleLabel
      if let viewController = self.navigationController?.viewControllers {

          if !viewController.contains(where: { return $0 is MerchantSearchViewController }) {
              self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(btnSearchClicked))
          }
      }else {
          self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "search"), style: .plain, target: self, action: #selector(btnSearchClicked))
      }
//        arrRefered.removeAll()
//              if searchBar.text == "" || searchBar.text!.count == 0 {
//                  arrRefered = baseCouponArray
//              }else {
//                  for data in baseCouponArray {
//                          arrRefered.append(data)
//                  }
//              }
//        searchBar.text = ""
//      tableRefered.reloadData()
    }
}
// MARK:-
// MARK:- UITableViewDelegate, UITableViewDataSource

extension FreindsOnMarketVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return arrRefered.count
      // return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "CouponOfferTableViewCell") as? CouponOfferTableViewCell{
//
//            if let data = arrRefered[indexPath.row] as? [String : Any] {
//                cell.lblName.text = data.valueForString(key: "name")
//
//            }
//          //  cell.lblEarns.attributedText = attributedEarns()
//            //  cell.lblName.text = data.valueForString(key: "name")
//            return cell
//        }else{
//            return UITableViewCell()
//        }
        //
       
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CouponOfferTableViewCell") as? CouponOfferTableViewCell {
          
            let item = self.arrRefered[indexPath.row]
            let subofferDctList = item["sub_offer"] as? [[String:Any]] ?? [[:]]
            let merchantDctList = item["merchant"] as? [[String:Any]] ?? [[:]]
            var  subofferDct: [String:Any]?
            var merchantDct :[String:Any]?
            
            if subofferDctList.count > 0 {
                subofferDct = subofferDctList[0]
            }
            
            if merchantDctList.count > 0 {
                 merchantDct = merchantDctList[0]
            }
            
            
            
             let expirydate = item.valueForString(key: "expiry_date")
            var couponImage = subofferDct?.valueForString(key: "coupon_image") ?? ""
             let website = merchantDct?.valueForString(key: "website") ?? ""
             let amount = subofferDct?.valueForString(key: "amount") ?? ""
            let conditions = subofferDct?.valueForString(key: "conditions") ?? ""
             let business_logo = merchantDct?.valueForString(key: "business_logo") ?? ""
             let name = merchantDct?.valueForString(key: "business_name") ?? ""
             let latitude = merchantDct?.valueForString(key: "latitude") ?? ""
             let longitude = merchantDct?.valueForString(key: "longitude") ?? ""
             let mobile_number = merchantDct?.valueForString(key: "mobile_number ") ?? ""
             let address = merchantDct?.valueForString(key: "address") ?? ""
             let tagline = merchantDct?.valueForString(key: "tagline") ?? ""
            // let country_code = merchantDct?.valueForString(key: "country_code") ?? ""
            cell.btnRedeem.tag = Int(item.valueForString(key: "merchant_id")) ?? 0
            cell.btnRedeem.touchUpInside { (_) in
              if let ScanQRCodeVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "CouponOfferQRViewController") as? CouponOfferQRViewController {
                  ScanQRCodeVC.merchant_ID = "\(cell.btnRedeem.tag)"
                ScanQRCodeVC.businessName = cell.lblName.text!
                ScanQRCodeVC.amount = cell.lblCoupon_Amount.text! 
                ScanQRCodeVC.business_logo = business_logo
                ScanQRCodeVC.expireDate = cell.lblExpiryDate.text!
                ScanQRCodeVC.condition = cell.lblCouponOffer.text!
            self.navigationController!.pushViewController(ScanQRCodeVC, animated: true)
            }
            }
            
           // cell.btnRedeem.addTarget(self, action: #selector(scanQRCode), for: .touchUpInside)
            cell.lblExpiryDate.text = item.valueForString(key: "expiry_date")
           cell.lblName.text = name
            cell.lblCouponOffer.text = conditions
            cell.lblAddress.text = address
//            cell.lblCoupon_Amount.text =  appDelegate!.currency + (amount )
            let amountD = formatter.number(from: amount)
                       cell.lblCoupon_Amount.text =  appDelegate!.currency + "\(Int(amountD ?? 0))"
           cell.lbl_tagline.text = tagline
            
            let string =   amount
            let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.red,
                .font: UIFont.boldSystemFont(ofSize: 14)
            ]

            let attributedString = NSAttributedString(string: string, attributes: attributes)
            let s = attributedString.string
          //  cell.lblCoupon_Amount.text = "Amount" + s + "Coupon"
            if website != ""{
                cell.btnWebsite.isHidden = false
            }else{
                cell.btnWebsite.isHidden = true
            }
            if mobile_number != ""{
                cell.btnPhone_Number.isHidden = false
            }else{
                cell.btnPhone_Number.isHidden = true
            }
            if address != ""{
                cell.btnDirection.isHidden = false
            }else{
                cell.btnDirection.isHidden = true
            }
            
           // let couponurl = URL(string:"\(couponImage)")
//           if let data = try? Data(contentsOf: couponurl!)
//           {
//            cell.couponImg.image = UIImage(data: data)
//           }
            cell.couponImg.sd_setImage(with: URL(string: "\(couponImage)"), placeholderImage: UIImage(named: "placeholder.png"))

            if business_logo != ""{
                let business_logourl = URL(string:"\(business_logo)")
                if let data = try? Data(contentsOf: business_logourl!)
                {
                cell.business_logoImageView.image = UIImage(data: data)
                }
            }else{
                cell.business_logoImageView.image = UIImage(named: "cust_welcom")
            }
           

            
         //   cell.btnWebsite.hide(byWidth: (website.isBlank))
            cell.btnWebsite.touchUpInside { (sender) in
                self.openInSafari(strUrl: website)
            }
            cell.btnPhone_Number.hide(byWidth: (mobile_number.isBlank))
            cell.btnPhone_Number.touchUpInside { (sender) in
                if let phoneURL = URL(string: "tel://\(mobile_number)"){
                    if self.application.canOpenURL(phoneURL){
                        self.application.open(phoneURL, options: [:], completionHandler: nil)
                          }else{
                              //alert
                          }
                      }
            }
          let add =  getAddressFromLatLon(pdblLatitude: latitude, withLongitude: longitude)
            cell.btnDirection.touchUpInside { (sender) in
                self.openGoogleMap(latitude, longitude: longitude, address: add)
               
//                let storyboard = UIStoryboard(name: "MainCustomer", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
//                vc.searchBar.text = address
//                self.navigationController?.pushViewController(vc, animated: true)
           }
            
            return cell
        }else{
           return UITableViewCell()
        }
        
        
    }
    
    @objc func website_Tapped() {
          if let url = URL(string: "https://google.com") {
          let config = SFSafariViewController.Configuration()
          config.entersReaderIfAvailable = true

          let vc = SFSafariViewController(url: url, configuration: config)
          present(vc, animated: true)
            
      }
       
    }
    
    @objc func direction_Tapped() {
        
            let storyboard = UIStoryboard(name: "MainCustomer", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
               self.navigationController?.pushViewController(vc, animated: true)
    
       
    }
    @objc func scanQRCode(sender: UIButton){
        if let ScanQRCodeVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "CouponOfferQRViewController") as? CouponOfferQRViewController {
            
            getRedeemOffer()
           
            self.navigationController!.pushViewController(ScanQRCodeVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 233
    }
    func attributedEarns() -> NSMutableAttributedString{
        
        //        let strSignUp = "NEW TO SMARKET? SIGN UP"
        let strSignUp = "Earns you 30%"
        
        let attributedString = NSMutableAttributedString(string: strSignUp)
        
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor : ColorBlack_000000,                                      NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: .regular)], range: NSRange(location: 0, length: strSignUp.count))
        
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor : ColorRedExpireDate,NSAttributedStringKey.font :
            UIFont.systemFont(ofSize: 16, weight: .semibold)],
                                       range:strSignUp.rangeOf("30%"))
        
        return attributedString
    }
}
extension FreindsOnMarketVC {
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) -> String {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)") ?? 0.0
        //21.228124
        let lon: Double = Double("\(pdblLongitude)") ?? 0.0
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)

        var addressString : String = ""
        var locality : String = ""
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
//                    print(pm.country)
//                    print(pm.locality)
//                    print(pm.subLocality)
//                    print(pm.thoroughfare)
//                    print(pm.postalCode)
//                    print(pm.subThoroughfare)
                    
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                        locality = locality + pm.locality!
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }


                    print(addressString)
              }
        })
       return locality
    }
    fileprivate func getRedeemOffer(){
        let param = ["user_id": appDelegate?.loginUser?.user_id]
        //redeemOffer
          
         APIRequest.shared().redeemOffer(param as [String : Any]) { (response, error) in
             if let json = response as? [String : Any], let data = json[CJsonData] as? [[String : Any]] {
                print("data is ...........>\(data)")
                 print("response is ......>\(response)")
                 for item:[String:Any] in data {
                     
                     self.arrayOfQRCodeData.append(item)
                     }
                     print("arrayOfQRCodeData.......>  \(self.arrayOfQRCodeData)")
                
             }
         }
    }
    
    fileprivate func getRefered(){
        
        let param = ["user_id": appDelegate?.loginUser?.user_id]
        arrRefered.removeAll()
        
        if arrRefered.count == 0  {
            tableRefered.startLoadingAnimation(tintColor: .gray, backgroundColor: .white)
        }
       
        APIRequest.shared().customerReferred(param as [String : Any]) { (response, error) in
         
           
            if let json = response as? [String : Any], let data = json[CJsonData] as? [[String : Any]] {
                
//                if let refer = data.valueForJSON(key: "refered"){
//
//                    self.arrRefered = refer as! [[String : Any]]
//                    print("array of data...........>",self.arrRefered)
//                    self.tableRefered.reloadData()
//                }
                
                for item:[String:Any] in data {
                    self.baseCouponArray.append(item)
                    
                    self.arrRefered.append(item)
                }
                
               
                print("array list.......>  \(self.arrRefered)")
                
                self.tableRefered.reloadData()
                
            }
            
            if self.arrRefered.count > 0 {
                self.tableRefered.stopLoadingAnimation()
                
            } else if error == nil {
                self.tableRefered.showDataStatusView(status: .noResultFound, tintColor: .gray, backgroundColor: .clear, tapToRetry: nil)
                
            } else if let error = error as NSError? {
                
                self.tableRefered.showDataStatusView(status: (error.code == -1001 || error.code == -1009) ? .noInternet : .other, tintColor: .gray, backgroundColor: .clear, tapToRetry: {
                    self.getRefered()
                })
            }
        }
    }
}


