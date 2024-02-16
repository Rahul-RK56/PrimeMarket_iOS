//
//  ReferralViewController.swift
//  SMarket
//
//  Created by CIPL0668 on 11/09/20.
//  Copyright © 2020 Mind. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftSoup
import SafariServices
import Alamofire
import WebKit

class ReferralCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblPrice : UILabel!
    @IBOutlet weak var lblRewards: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var imgCompany: UIImageView!
    @IBOutlet weak var lblMerchent: UILabel!
    @IBOutlet weak var btnMore : UIButton!
    
    @IBOutlet weak var topBtnMore: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

struct Product {
    var title : String?
    var imgURL : String?
    var logoURL : String?
    var price : String?
    var percentage : Int?
    var site : String?
    var rewards : String?
    var url : String?
}

class ReferralViewController: ParentViewController, WKNavigationDelegate {
    @IBOutlet weak var lblRedeem : UILabel!
    @IBOutlet weak var lblFriends : UILabel!
    @IBOutlet weak var lblRefer : UILabel!
    @IBOutlet weak var lblEach : UILabel!
    @IBOutlet weak var tableRefer : UITableView!
    @IBOutlet weak var viewReferBanner : UIView!
    @IBOutlet weak var btnProduct : UIButton!
    @IBOutlet weak var btnProduct1 : UIButton!
    @IBOutlet weak var heightProduct: NSLayoutConstraint!
    @IBOutlet weak var heightProduct1: NSLayoutConstraint!
    @IBOutlet weak var loader : UIView!
    @IBOutlet weak var vCircular : UIView!
    @IBOutlet weak var lblLoader: UILabel!
    @IBOutlet weak var lblBorder: UILabel!
    @IBOutlet weak var lblHint: UILabel!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var viewReferBannerNew : UIView!
    var viewReferNew : UIView?
    @IBOutlet weak var lblOffer1: UILabel!
    @IBOutlet weak var lblOffer2: UILabel!
    @IBOutlet weak var lblOffer3: UILabel!
    @IBOutlet weak var btnContact : UIButton!
    @IBOutlet weak var tableBottomConstant: NSLayoutConstraint!
    
    @IBOutlet weak var offerPopupViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var offerStackViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var offer2View: UIView!
    @IBOutlet weak var offer1View: UIView!
    
    let formatter = NumberFormatter()
    
    var viewRefer : UIView?
    var imgBannerFlag = false
    var states : Array<Bool>!
    var viewLoader : UIView?
    typealias Item = (text: String, html: String)
    var document: Document = Document.init("")
    var items: [Item] = []
    var firstPrd : [String:Any] = [:]
    var arrayProducts : [Product] = []
    var arrayURL : [String] = []
    var arrayKeys : [[String]] = []
    var ptitle = ""
    var ptitleOld = ""
    var rewardP = 0.0
    var selectedRow = 0
    var redirectURL = ""
    var isLoading = false
    var isGoProductTapped = false
    var shareURL = ""
    var share_text = ""
    var isInvite = false
    var isClose = false
    var detailTitle = ""
    var country = "india"
    var viglinkUrl = "https://rest.viglink.com/api/product/metadata?url="
    var linkURL = "https://linksredirect.com/?cid=125043&source=linkkit&url="
    var linkArray = ["mynthra","ajio","pharmeasy","nykaa","paytmmall","tatacliq","shopclues","aliexpress","macy","walmart","amazon","flipkart"]
    var arrayMKeys : [[String:Any]] = []
    var currentMKey : [String:Any] = [:]
    var currentIndex = 0
    
    var webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        webView.navigationDelegate = self
        
        if let getCountry = CUserDefaults.value(forKey: UserDefaultCountryCode) {
            if  getCountry as! String == "+91" {
                country = "india"
            }else{
                country = "usa"
            }
        }
        initialize()
    }
    
    @IBAction func contactUsButtonHandler(){
        if let dict = CUserDefaults.value(forKey: UserDefaultContactUs)  as? [String : Any]{
            let email = dict.valueForString(key: "cms_desc").htmlToString
            if !email.isBlank {
                appDelegate?.openMailComposer(self, email: email)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        offer1View.isHidden = true
//        offer2View.isHidden = true
//        smarketOfferViewHeightConstraints.constant = 320
//        offerStackViewHeightConstraints.constant = 80
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if isInvite{
            showBannerPopup()
            lblHint.isHidden = true
            stack.isHidden = true
            lblHint.isHidden = true
            self.title = "INVITE FRIENDS"
//            goProductBtnHandler()
        
        }else{
            lblHint.isHidden = false
            stack.isHidden = false
            lblHint.isHidden = false
            configureBanner()
            if Connectivity.isConnectedToInternet() {
                if arrayMKeys.count == 0{
                    initShare()
                }else{
                    self.loadParsing()
                }
            }else{
                self.showAlertView(CMessageNoInternet, completion: { (action) in
                })
            }
        }
    }
    
    func initShare(){
        
        if let prefs = UserDefaults(suiteName: appDelegate?.suiteName),(prefs.object(forKey: "ShareText") != nil) {
            let shareText = prefs.object(forKey: "ShareText") as! String
            isLoading = true
            print(shareURL,"shareurl--")
            shareURL = String(shareText.suffix(from: "https://".startIndex))
            share_text = shareURL
            print(shareURL,"shareurl-->>>>>>")
        }else{
            print(shareURL,"shareurl")
        }
        showBannerImage()
        getHtmlParsingKeys()
    }
    
    
    func loadParsing(){
        
        if(!isGoProductTapped){
            if getSite(url: shareURL) == "others" {
                
                self.arrayProducts.removeAll()
                arrayURL.removeAll()
                arrayKeys.removeAll()
                tableRefer.reloadData()
                getViglink()
            }
            else{
                
                self.showLoader()
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    
                    self.arrayProducts.removeAll()
                    self.arrayURL.removeAll()
                    self.arrayKeys.removeAll()
                    self.tableRefer.reloadData()
                    self.getParseSharedURL()
                }
            }
        }
        isGoProductTapped = false
    }
    
    //Download HTML
    func parseHTML(strUrl: String,dataKey:[String:Any],search:Bool = false) -> Void {
     
        Alamofire.request(strUrl).responseString { [self] response in
            if let html = response.result.value {
                do {
                    self.document = try SwiftSoup.parse(html)
                    self.startParseSite(dataKey: dataKey,sUrl: strUrl,search: search)
                }
                catch let error {
                    print("error \(error)")
                }
            }
        }
    }
    
    func startParseSite(dataKey:[String:Any],sUrl:String,search:Bool = false){
        
        if search{
            self.parse(key: dataKey, urlStr:sUrl, detail: true)
        }else{
            
            let keyD = dataKey["key_details"] as! [String:AnyObject]
            let valueD = keyD["key"] as! [String:String]
            if valueD["price"]! == "0"{
                self.parseViglink(key: valueD["title"]!, urlStr: valueD["image"]!, lUrl: dataKey["image"] as! String, per: dataKey["percentage"] as! Int)
            }
            else{
                self.parse(key: dataKey, urlStr:sUrl, detail: (currentIndex == 0) ? true : false)
            }
        }
    }
    
    func checkHTMLDownload(){
        currentIndex = currentIndex + 1
        if currentIndex < arrayMKeys.count{
            downloadHTML()
        }
        if(currentIndex == arrayMKeys.count){
            self.hideloader()
            if self.arrayProducts.count == 0 {
                self.tableRefer.showDataStatusView(status: .inProgress, tintColor: .gray, backgroundColor: .clear, tapToRetry: nil)
                
            }
            self.states = [Bool](repeating: true, count: self.arrayProducts.count)
        }
    }
    
    func downloadHTML() {
        
        currentMKey = arrayMKeys[currentIndex]
        if currentMKey["country"] as! String == country {
            var strUrl = ""
            if currentIndex == 0{
                strUrl = shareURL
            }else{
                strUrl = "\(currentMKey["url"] as! String)\(ptitle)"
            }
            parseHTML(strUrl: strUrl,dataKey: currentMKey)
        }else{
            checkHTMLDownload()
        }
    }
    
    func parseViglink(key:String,urlStr:String,lUrl:String,per:Int){
        do {
            let pURL = try document.getElementsByClass(key).first()?.select("a").first()?.attr("href")
            getParseViglink(url: "\(urlStr)\(pURL ?? "")", imgUrl: lUrl, per: per)
        }
        catch let error {
            print("error \(error)")
        }
    }
    
    func parse(key:[String:Any],urlStr:String,detail:Bool) {
        
        do {
            
            items = []
            var product = Product()
            
            product.site = getSite(url: urlStr)
            product.url = urlStr
            product.logoURL = key["image"] as? String
            product.percentage = key["percentage"] as? Int
            
            var  i = 0
            var keysP : [String] = []
            var keysP2 : [String] = []
            var keysP3 : [String] = []
            
            
            
            let keyD = key["key_details"] as! [String:AnyObject]
            
            if detail{
                let valueD = keyD["detail"] as! [String:String]
                keysP = [valueD["title"]!,valueD["price"]!,valueD["image"]!]
                if let valueD2 = keyD["detail2"] as? [String:String]{
                    keysP2 = [valueD2["title"]!,valueD2["price"]!,valueD2["image"]!]
                }
                if let valueD3 = keyD["detail3"] as? [String:String]{
                    keysP3 = [valueD3["title"]!,valueD3["price"]!,valueD3["image"]!]
                }
            }else{
                let valueD = keyD["key"] as! [String:String]
                keysP = [valueD["title"]!,valueD["price"]!,valueD["image"]!]
                if let valueD2 = keyD["key2"] as? [String:String]{
                    keysP2 = [valueD2["title"]!,valueD2["price"]!,valueD2["image"]!]
                }
                if let valueD3 = keyD["key3"] as? [String:String]{
                    keysP3 = [valueD3["title"]!,valueD3["price"]!,valueD3["image"]!]
                }
            }
            
            for k in keysP {
                var elements = try document.getElementsByClass(k)
                if arrayProducts.count > 0 && i==0 && detail == false{
                    if getSite(url: shareURL) != "others" {
                        var titleKey = keysP[1]
                        if elements.count == 0 && product.site == "flipkart"{
                            elements = try document.getElementsByClass(keysP2[0])
                            titleKey = keysP2[0]
                        }
                        let indexS = self.getSearchOptimse(elements: elements, site: product.site!, keyT: titleKey)
                        if indexS == 100{
                            break
                        }
                        var urlST = try elements[indexS].attr("href")
                        if product.site == "reliancedigital"{
                            urlST = try elements.select("a")[indexS].attr("href")
                        }
                        var newUrl = "\(keysP[2])\(urlST)"
                        if product.site == "ebay" || product.site == "newegg"{
                            newUrl = urlST
                        }
                        parseHTML(strUrl: newUrl,dataKey: key,search: true)
                        return
                    }
                }
                if (product.site == "a.co"){
                    print(try document.getElementById(k)?.text() ?? "")
                }
                // Title
                if i == 0{
                    product.title = try elements.first()?.text()
                   
                    if(product.site == "a.co" || product.site == "amzn.eu") {
                        product.title = try document.getElementById(k)?.text() ?? ""
                    
                    }
                    else if(product.site == "flipkart" &&  product.title == "") {
                        product.title = try document.getElementsByClass(keysP2[0]).first()?.text()
                    }
                    else if(product.site == "ebay" &&  (product.title == "" || product.title == nil)) {
                        product.title = try document.getElementsByClass(keysP2[0]).first()?.text() ?? ""
                        product.title =  product.title?.replacingOccurrences(of: "Details about", with: "").trim
                    }
                    if product.title != "" && product.title != nil{
                        self.getPTitle(titleS:product.title!)
                    }
                }
                // Price
                else if i == 1{
                    product.price = try elements.first()?.text()
                    
                    if(product.site == "ebay" && (product.price == "" || product.price == nil)) {
                        product.price = try document.getElementsByClass(keysP2[1]).first()?.text() ?? ""
                    }
                    else if(product.site == "newegg") {
                        product.price = try document.getElementsByClass(k).first()?.text() ?? ""
                    }
                    else if(product.site == "a.co" || product.site == "amzn.eu") {
                       // product.price = try document.getElementById(k)?.text() ?? ""
                        product.price = try? document.getElementsByClass(keysP[1]).first()?.text() ?? ""
                                           }
                    
                   if(product.site == "amzn.eu" &&  product.price == "") {
                  //  product.price = try document.getElementsByClass(keysP2[1]).first()?.text() ?? ""
                       if keysP2.count > 0 {
                           print("getElementsByClass---- ",keysP2.count)
                           product.price = try? document.getElementsByClass(keysP2[1]).first()?.text() ?? ""
                       }
                    }
                    
                    if(product.site == "a.co" &&  product.price == "") {
                   //  product.price = try document.getElementsByClass(keysP2[1]).first()?.text() ?? ""
                        if keysP2.count > 0 {
                            print("getElementsByClass---- ",keysP2.count)
                            product.price = try? document.getElementsByClass(keysP2[1]).first()?.text() ?? ""
                        }
                     }
                  
                    
                    if (product.price == "" ||  product.price == nil){
                        product.price  = "No Price"
                    }
                }
                // Image
                else if i == 2{
                    
                    product.imgURL = try elements.first()?.attr("src")
                    
                    if(product.site == "amzn.eu" || product.site == "a.co") {
                        product.imgURL = try elements.first()?.attr(keysP2[1]) ?? ""
                    }
                    if (product.site == "amzn.eu" || product.site == "a.co") &&  product.imgURL == "" {
                        product.imgURL = try document.getElementById(keysP[2])?.getElementsByTag("img").attr("src")
                    }
                    else if(product.site == "walmart" ){
                        product.imgURL = try elements.first()?.childNode(0).attr("src") ?? ""
                        product.imgURL = "https:\(product.imgURL ?? "")"
                    }
                    else if(product.site == "ebay" && (product.imgURL == "" || product.imgURL == nil)) {
                        if keysP2.count > 0 {
                            product.imgURL = try document.getElementsByClass("\(keysP2[2]) ").first?.attr("src") ?? ""
                        }
                    }
                    else if(product.site == "reliancedigital" ){
                        product.imgURL = "https://www.reliancedigital.in\(try elements.first()?.select("img").first()?.attr("data-srcset") ?? "0")"
                    }
                   
                }
                i = i + 1
            }
            
            if  product.site == "flipkart"{
                getParseViglinkFlipkart(url: product.url ?? "")
            }
            
            checkHTMLDownload()
            
            if(product.title == "" || product.price == "" || product.title == nil || product.price == nil ){
                print(product.title,"title")
                print(product.price,"price")
                print("product not found")
            }
            else{
                arrayProducts.removeAll()
                arrayProducts.append(product)
                DispatchQueue.main.async {
                    self.tableRefer.reloadData()
                    //self.scrollLastIndex()
                }
            }
        } catch let error {
            print("error \(error)")
        }
    }
    
    func getSearchOptimse(elements:Elements,site:String,keyT:String) -> Int{
        do {
            let firstTitle = arrayProducts[0].title?.lowercased().stripped.components(separatedBy: " ")
            var arrayFilter :[Int] = []
            for i in 0 ..< elements.count{
                let title = try (elements[i].getElementsByClass(keyT).text()).lowercased().stripped.components(separatedBy: " ")
                print(title.joined(separator: " "))
                let newArray  = firstTitle!.filter { (string) -> Bool in
                    return title.contains(string)
                }
                if(newArray.count > 0){
                    arrayFilter.append(newArray.count)
                }else{
                    arrayFilter.append(0)
                }
                print (newArray.count)
            }
            if let ind = arrayFilter.indexOfMax , arrayFilter[ind] > 2{
                return ind
            }else{
                return  100
            }
        } catch let error {
            print("error \(error)")
        }
        return  100
    }
    
    func getSearchOptimseViglink(title:String) -> Bool{
        let firstTitle = arrayProducts[0].title?.lowercased().stripped.components(separatedBy: " ")
        let second = title.lowercased().stripped.components(separatedBy: " ")
        
        let newArray  = firstTitle!.filter { (string) -> Bool in
            return second.contains(string)
        }
        if(newArray.count > 0){
            return true
        }else{
            return false
        }
    }
    
    func scrollLastIndex(){
        let pathToLastRow = IndexPath.init(row:  self.arrayProducts.count - 1, section: 0)
        tableRefer.scrollToRow(at: pathToLastRow, at: .bottom, animated: true)
    }
    
    func getSite(url : String) -> String{
        
         for dateKey in arrayMKeys{
            
            if url.contains(dateKey["name"] as! String){
                print("arrayMKeys-->>> ",dateKey["name"])

                return dateKey["name"] as! String
            }
        }
        return "others"
    }
    
    func getSiteURL(url : String) -> String{
        
        for dateKey in arrayMKeys{
            if url.contains(dateKey["url"] as! String){
                return dateKey["url"] as! String
            }
        }
        return shareURL
    }
    
    func getViglink(){
        
        var sUrl = ""
        
        if share_text != "" {
            sUrl = share_text
        }
//        if let prefs = UserDefaults(suiteName: appDelegate?.suiteName) {
//            if let sur = UserDefaults(suiteName: appDelegate?.suiteName),(prefs.object(forKey: "ShareText") != nil) {
////            if let sur =  prefs.object(forKey: "ShareText"){
//                sUrl = sur as? String ?? ""
//                print("sUrl--- ",sUrl)
//
//            }else {
//                print("sUrl ",sUrl)
////                return
//            }
//        }
        viglinkUrl = "\(viglinkUrl)\(sUrl)"
        guard let url = (URL(string: viglinkUrl)) else {return}
        var request = URLRequest(url: url)
//        var request = URLRequest(url: URL(string: viglinkUrl)!)
        request.setValue("0bcbd92ab7b7789fc98dca6cd281a31228d6405b", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        lblLoader.text = "fetching deals"
        lblLoader.textColor =  CRGB(r: 252, g: 79, b: 186)
        
        self.showLoader()
        DispatchQueue.global(qos: .background).async {
            session.dataTask(with:request) { (data, response, error) in
                
                if let data = data {
                    do {
                        self.firstPrd = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                        guard let titleS =  self.firstPrd["title"] else {
                            DispatchQueue.main.async {
                                self.hideloader()
                            }
                            return
                        }
                        self.ptitleOld = titleS as! String
                        self.getPTitle(titleS: titleS as! String)
                        
                        var product = Product()
                        product.title = (self.firstPrd["title"] as! String)
                        if let url = self.firstPrd["imageUrl"]  as? String{
                            product.imgURL = url
                        }else{
                            product.imgURL = ""
                        }
                        if let price = self.firstPrd["price"]  as? String{
                            product.price = price
                        }else{
                            product.price = ""
                        }
                        product.site = self.getSite(url: sUrl)
                        product.url = self.getSiteURL(url: sUrl)
                        self.arrayProducts.removeAll()
                        self.arrayProducts.append(product)
                        
                        DispatchQueue.main.async {
                            self.loadSites()
                        }
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    func getParseViglink(url:String,imgUrl:String,per:Int){
        var request = URLRequest(url: URL(string: "\(viglinkUrl)\(url)")!)
        request.setValue("0bcbd92ab7b7789fc98dca6cd281a31228d6405b", forHTTPHeaderField: "Authorization")
        DispatchQueue.main.async {
            self.showLoader()
        }
        
        let session = URLSession.shared
        DispatchQueue.global(qos: .background).async {
            session.dataTask(with:request) { (data, response, error) in
                DispatchQueue.main.async {
                    self.hideloader()
                    if let data = data {
                        do {
                            let productData = try JSONSerialization.jsonObject(with: data, options:[]) as! [String : Any]
                            var product = Product()
                            product.title = (productData["title"] as? String)
                            if productData["imageUrl"] as? NSNull == nil {
                                product.imgURL = (productData["imageUrl"] as? String)
                            }
                            product.price = (productData["price"] as? String)
                            product.site = self.getSite(url: url)
                            product.url = self.getSiteURL(url: url)
                            product.logoURL = imgUrl
                            product.percentage = per
                            if self.getSearchOptimseViglink(title: product.title!){
                                self.arrayProducts.removeAll()
                                self.arrayProducts.append(product)
                            }
                            self.tableRefer.reloadData()
                            // self.scrollLastIndex()
                        } catch {
                            print(error)
                        }
                    }
                }
                
            }.resume()
        }
    }
    
    func getParseViglinkFlipkart(url:String){
        var request = URLRequest(url: URL(string: "\(viglinkUrl)\(url)")!)
        request.setValue("0bcbd92ab7b7789fc98dca6cd281a31228d6405b", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        DispatchQueue.global(qos: .background).async {
            session.dataTask(with:request) { (data, response, error) in
                DispatchQueue.main.async {
                    if let data = data {
                        do {
                            let productData = try JSONSerialization.jsonObject(with: data, options:[]) as! [String : Any]
                            if let fIndex = self.arrayProducts.firstIndex(where: ({$0.site == "flipkart"})){
                                
                                if productData["imageUrl"] as? NSNull == nil  {
                                    self.arrayProducts[fIndex].imgURL = (productData["imageUrl"] as? String)
                                }
                            }
                            self.tableRefer.reloadData()
                        } catch {
                            print(error)
                        }
                    }
                }
                
            }.resume()
        }
    }
    
    func loadSites(){
        arrayURL = arrayMKeys.map({$0["url"] as! String})
        self.showLoader2()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { [self] in
            self.currentIndex = 0
            self.downloadHTML()
        }
    }
    
    func getPTitle(titleS:String){
        let newT = titleS.stripped.components(separatedBy: " ")
        if newT.count > 3{
            var a = ""
            for t in 0 ..< 3{
                a = "\(a) \(newT[t])"
            }
            self.ptitle = a.trim
        }else{
            self.ptitle = titleS
        }
        self.ptitle = (self.ptitle).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    
    func getParseSharedURL(){
        do {
            let html = try String.init(contentsOf: URL(string: shareURL)!, encoding: String.Encoding.utf8)
            document = try SwiftSoup.parse(html)
            for (index,dateKey) in arrayMKeys.enumerated(){
                if shareURL.contains(dateKey["name"] as! String){
                    arrayMKeys.remove(at: index)
                    arrayMKeys.insert(dateKey, at: 0)
                    loadSites()
                    return
                }
            }
            loadSites()
        } catch let error {
            print("error \(error)")
        }
    }
    
    fileprivate func initialize()  {
        lblOffer1.attributedText = attributedSuperscript(text: "₹50", loc: 0)
        lblOffer2.attributedText = attributedSuperscript(text: "₹20", loc: 0)
        lblOffer3.attributedText = attributedSuperscript(text: "30%", loc: 2)
        
        viewRefer = UIView.init(frame: self.view.frame)
        viewRefer?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.navigationController?.view.addSubview(viewRefer!)
        
        viewReferNew = UIView.init(frame: self.view.frame)
        viewReferNew?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.navigationController?.view.addSubview(viewReferNew!)
        
        viewRefer?.addSubview(viewReferBanner)
        viewReferNew?.addSubview(viewReferBannerNew)
        
        lblEach.attributedText = attributedEachTime()
        lblRefer.attributedText = attributedRefer()
        btnProduct.titleLabel?.attributedText = attributedProduct()
        viewRefer!.isHidden = true
        viewReferNew!.isHidden = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hideBannerPopup))
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(hideBannerPopup))
        viewReferNew?.addGestureRecognizer(tap)
        viewRefer?.addGestureRecognizer(tap2)
        if let dict = CUserDefaults.value(forKey: UserDefaultContactUs)  as? [String : Any]{
            let email = dict.valueForString(key: "cms_desc").htmlToString
            if !email.isBlank {
                btnContact.setTitle("Contact us: \(email)", for: .normal)
            }
        }
    }
    
    func configureBanner(){
//        lblRedeem.text = appDelegate?.loginUser?.refcash ?? "0"
        let redeemA = formatter.number(from: "\(appDelegate?.loginUser?.refcash ?? "0")")
               lblRedeem.text = "\(Int(redeemA ?? 0))"
        let imgView = UIImageView(image: UIImage(named: "banner1"))
        imgView.contentMode = .scaleAspectFill
        imgView.frame = self.navigationController!.navigationBar.bounds
        imgView.tag = 50
        self.navigationController?.navigationBar.addSubview(imgView)
        
        let button = UIButton.init(frame: CGRect(x: 50, y: 0, width: imgView.frame.size.width-50, height: imgView.frame.size.height))
        button.tag = 52
        button.addTarget(self, action: #selector(showBannerPopup), for: .touchUpInside)
        self.navigationController?.navigationBar.addSubview(button)
        
        let imgBck = UIImageView(image:#imageLiteral(resourceName: "menu"))
        imgBck.frame = CGRect(x: 15, y: 27, width: 33, height: 18)
        imgBck.tag = 51
        self.navigationController?.navigationBar.addSubview(imgBck)
//        self.lblFriends.text =  appDelegate?.referred
        let friiendsA = formatter.number(from: "\(appDelegate?.referred)")
                self.lblFriends.text =  "\(friiendsA ?? 0)"
        updateImage()
        if appDelegate?.reward == 0.0{
            getRewardPercent()
        }else{
            if let rew = appDelegate?.reward{
                self.rewardP = rew
            }
        }
    }
    
    func showLoader(){
        hideloader()
        tableRefer.tableFooterView = loader
        vCircular.addSubview(MILoader.circularView)
        MILoader.self.startCircularRingAnimation()
        //        viewLoader?.isHidden = false
    }
    func showLoader2(){
        self.lblLoader.text = "comparing deals"
        self.lblLoader.textColor =  CRGB(r: 9, g: 164, b: 79)
    }
    func hideloader(){
        MILoader.self.hideCircularRing()
        tableRefer.tableFooterView = UIView()
        //        viewLoader?.isHidden = true
    }
    override func viewDidLayoutSubviews() {
        viewRefer!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height)
        viewReferBanner.frame = viewRefer!.frame
        
        viewReferNew!.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height:  UIScreen.main.bounds.size.height)
        viewReferBannerNew.frame = viewReferNew!.frame
        
        if let view = self.navigationController?.navigationBar.viewWithTag(50){
            view.frame = self.navigationController!.navigationBar.bounds
            if let bck = self.navigationController?.navigationBar.viewWithTag(52){
                bck.frame = CGRect(x: 50, y: 0, width: view.frame.size.width-50, height: view.frame.size.height)
            }
        }
        
    }
    @IBAction func inviteSmarketButtonHandler(){
        viewRefer!.isHidden = true
        viewReferNew!.isHidden = true
        
        hideBannerImage()
        isGoProductTapped = true
        
        if let recommendVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "RecommendToFriendsViewController") as? RecommendToFriendsViewController {
            self.navigationController?.pushViewController(recommendVC, animated: true)
        }
    }
    @IBAction func faqButtonHandler(){
        viewRefer!.isHidden = true
        viewReferNew!.isHidden = true
        
        hideBannerImage()
        isGoProductTapped = true
        
        if let recommendVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "FAQViewController") as? FAQViewController {
            self.navigationController?.pushViewController(recommendVC, animated: true)
        }
    }
    @IBAction func redeemButtonHandler(){
        //        isGoProductTapped = true
        
        //        viewRefer!.isHidden = true
        //        hideBannerImage()
        //
        //        if let refCashVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "RefcashViewController") as? RefcashViewController {
        //            refCashVC.view.tag = 200
        //            appDelegate?.sideMenuViewController?.mainViewController = UINavigationController(rootViewController: refCashVC)
        //        }
        
    }
    
    @IBAction func inviteSocialButtonHandler(){
        
        if !isInvite{
            viewRefer!.isHidden = true
            viewReferNew!.isHidden = true
        }
        
        var text = (CUserDefaults.value(forKey: UserDefaultReferralMsg) as! String)
        text = text.replacingOccurrences(of: "XXXXXX", with: CUserDefaults.value(forKey: UserDefaultReferralCode) as! String)
        
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UserDefaults.standard.set("", forKey: "weburl")
        print("finish to load")

        if let url = webView.url?.absoluteString{
            UserDefaults.standard.set(url, forKey: "weburl")
            print("url = \(url)")
        }
    }
    
    @IBAction func goProductBtnHandler(){
        
        redirectURL = ""
        let product = arrayProducts[selectedRow]
        
        let url = product.url ?? ""
        
//        DispatchQueue.main.async {
//            let url = URL(string: self.shareURL)
//            self.webView.load(URLRequest(url: url!))
//        }
        
        if (product.site == "amzn.eu"){ // amazon.in
            
            if(selectedRow == 0){
//                DispatchQueue.main.async {
//                    let url = URL(string: self.shareURL)
//                    self.webView.load(URLRequest(url: url!))
                    if UserDefaults.standard.string(forKey: "weburl") != "" {
                        var web_url =  UserDefaults.standard.string(forKey: "weburl") ?? ""
                        self.redirectURL = "\(web_url)&tag=smarketindia-21"
                        print("redirectURL----  ",self.redirectURL)
                    }else{
                        self.redirectURL = "\(self.shareURL)"
                        print("redirectURL---->>>>>  ",self.redirectURL)
                    }
//                }
//                redirectURL = "\(shareURL)/&tag=smarketindia-21" // "\(shareURL)/ref=as_li_ss_tl?ie=UTF8&linkCode=ll1&tag=smarketindia-21"
            }else{
                redirectURL = "\(url)/&linkCode=ll1&tag=smarketindia-21"
            }
        }else if(product.site == "ebay"){
            
            redirectURL = "https://rover.ebay.com/rover/1/711-53200-19255-0/1?campid=5338693049&customid=\(appDelegate?.loginUser?.mobile ?? "")!&toolid=20006&mpre=https://www.ebay.com/sch/i.html?_nkw=\(ptitle)"
        }else if(product.site == "a.co"){ //amazon.com
            
            if(selectedRow == 0){
                redirectURL = "\(url)/ref=as_li_ss_tl?ie=UTF8&linkCode=ll1&tag=smarket0f-20"
            }else{
                redirectURL = "\(url)/&linkCode=ll1&tag=smarket0f-20"
            }
        }else {
            
            getRedirectURL(url: url)
            if redirectURL == ""{
                redirectURL = "http://redirect.viglink.com?u=\(url)&key=f5e38af288c412320cf9ff35e2299c98"
            }
        }
        print("redirectURL-- ",redirectURL)
        isGoProductTapped = true
        viewRefer!.isHidden = true
        viewReferNew!.isHidden = true
        userActivity()
    }
    
    func getRedirectURL(url:String){
        
        for store in linkArray{
            if url.contains(store){
                redirectURL = "\(linkURL)\(url)"
                return
            }
        }
    }
    
    @objc func showBannerPopup(){
        
        if country == "india"{
            viewReferNew!.isHidden = false
        }else{
            viewRefer!.isHidden = false
        }
        btnProduct.isHidden = true
        btnProduct1.isHidden = true
        heightProduct.constant = 0
        heightProduct1.constant = 0
        
    }
    
    @objc func hideBannerPopup(){
        if isClose{
            appDelegate?.sideMenuViewController?.setDrawerState(.opened, animated: true)
        }
        viewRefer!.isHidden = true
        viewReferNew!.isHidden = true
        NotificationCenter.default.post(name: Notification.Name("NotifyCloseRefer"), object: nil)
        
    }
    
    func updateImage(){
        if let view = self.navigationController?.navigationBar.viewWithTag(50){
            let imgview = view as! UIImageView
            self.imgBannerFlag = !self.imgBannerFlag
            if(self.imgBannerFlag){
                imgview.image = UIImage(named: "banner1")
            }else{
                imgview.image = UIImage(named: "banner2")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.updateImage()
            }
        }
    }
    
    @IBAction func friendsOnSmarketButtonHandler(sender:UIButton){
        isGoProductTapped = true
        if let resetVC = CMainCustomer_SB.instantiateViewController(withIdentifier: "FreindsOnMarketVC") as? FreindsOnMarketVC {
            hideBannerImage()
            self.navigationController?.pushViewController(resetVC, animated: true)
        }
    }
    
    func hideBannerImage(){
        if let view = self.navigationController?.navigationBar.viewWithTag(50){
            view.isHidden = true
        }
        if let viewBack = self.navigationController?.navigationBar.viewWithTag(51){
            viewBack.isHidden = true
        }
        if let bck = self.navigationController?.navigationBar.viewWithTag(52){
            bck.isHidden = true
        }
    }
    func showBannerImage(){
        
        if let view = self.navigationController?.navigationBar.viewWithTag(50){
            view.isHidden = false
        }
        if let viewBack = self.navigationController?.navigationBar.viewWithTag(51){
            viewBack.isHidden = false
        }
        if let bck = self.navigationController?.navigationBar.viewWithTag(52){
            bck.isHidden = false
        }
    }
    
    func attributedSuperscript(text:String,loc:Int) -> NSMutableAttributedString{
        
        let font:UIFont? = UIFont.systemFont(ofSize: 38, weight: .bold)
        let fontSuper:UIFont? = UIFont.systemFont(ofSize: 26, weight: .bold)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [.font:font!])
        attString.setAttributes([.font:fontSuper!,.baselineOffset:10], range: NSRange(location:loc,length:1))
        return attString
    }
    
    func attributedProduct() -> NSMutableAttributedString{
        
        let strSignUp = "Go to product"
        
        let attributedString = NSMutableAttributedString(string: strSignUp)
        
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor :  CRGB(r: 238, g: 79, b: 179),NSAttributedStringKey.font :CFontPoppins(size:16,type:.SemiBold),NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue], range: NSRange(location: 0, length: strSignUp.count))
        
        return attributedString
    }
    
    func attributedEachTime() -> NSMutableAttributedString{
        
        let strSignUp = "Each time your referral shops through SMARKET we deposit you 30% of the rewards thery earn for LIFETIME"
        
        let attributedString = NSMutableAttributedString(string: strSignUp)
        
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor :  CRGB(r: 0, g: 79, b: 89),NSAttributedStringKey.font :CFontPoppins(size:12, type: .Regular)], range: NSRange(location: 0, length: strSignUp.count))
        
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor : CRGB(r: 0, g: 79, b: 89),NSAttributedStringKey.font : CFontPoppins(size:18, type: .SemiBold)],range:strSignUp.rangeOf("30%"))
        
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor : ColorRedExpireDate,NSAttributedStringKey.font :
                                            CFontPoppins(size:18, type: .SemiBold)],
                                       range:strSignUp.rangeOf("LIFETIME"))
        
        return attributedString
    }
    
    func attributedRefer() -> NSMutableAttributedString{
        
        let strSignUp = "Refer friends to earn\n 30%\n Lifetime cash rewards"
        
        let attributedString = NSMutableAttributedString(string: strSignUp)
        
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor : ColorWhite_FFFFFF,                                      NSAttributedStringKey.font :CFontPoppins(size:12, type: .Medium)], range: NSRange(location: 0, length: strSignUp.count))
        
        attributedString.setAttributes([NSAttributedStringKey.foregroundColor : CRGB(r: 209, g: 231, b: 77),NSAttributedStringKey.font :
                                            CFontPoppins(size:24, type: .SemiBold)],
                                       range:strSignUp.rangeOf("30%"))
        return attributedString
    }
    
}

extension ReferralViewController {
    
    fileprivate func getRewardPercent(){
        
        APIRequest.shared().rewardPercent() { (response, error) in
            if let json = response as? [String : Any], let data = json[CJsonData] as? [String : Any] {
                print(data)
                if (self.isLoading){
                    self.showLoader()
                }
                let rew = data["rewardpercent"] as! [String : Any]
                self.rewardP = rew["customer_percent"] as! Double
                appDelegate?.reward = self.rewardP
            }
        }
    }
    
    fileprivate func userActivity(){
        
        let prod = arrayProducts[selectedRow]
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd h:mm:a"
        let dateS = dateFormat.string(from: Date())
        
        let param = ["user_id": appDelegate?.loginUser?.user_id,
                     "rewards_value": prod.rewards,
                     "product_url": prod.url,
                     "product_image_url": prod.imgURL,
                     "clicked_at": dateS,
                     "merchant_name": prod.site,
                     "phone_number": appDelegate?.loginUser?.mobile,
                     "device_type": "iOS",
                     "product_price": prod.price,
                     "status": "1",
                     "product_name":  prod.title
        ]
        
        APIRequest.shared().userActivity(param as [String : Any]) { (response, error) in
            
            if let json = response as? [String : Any], let data = json[CJsonData] as? [String : Any] {
                print(data)
                self.showSafari()
            }
        }
    }
    
    func showSafari() {
        if let url = URL(string: redirectURL) {
            UIApplication.shared.open(url)
        }
    }
}
extension ReferralViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReferralCell") as? ReferralCell{
            cell.selectionStyle = .none
            var product = arrayProducts[indexPath.row]
            
            cell.lblTitle.text = product.title ?? ""
            cell.lblTitle.lineBreakMode = .byWordWrapping
            cell.lblTitle.layoutIfNeeded()
            
            if((cell.btnMore.isSelected ? cell.lblTitle.lastLineWidth : cell.lblTitle.secondLineWidth) < cell.lblTitle.frame.size.width - 54){
                cell.topBtnMore.constant = -5
            }else{
                cell.topBtnMore.constant = 0
            }
            
//            cell.lblPrice.text = product.price
            var priceD = product.price?.replacingOccurrences(of: "₹", with: "") ?? "1"
                       priceD = priceD.replacingOccurrences(of: "Rs.", with: "")
                       priceD = priceD.replacingOccurrences(of: "INR", with: "")
                       priceD = priceD.replacingOccurrences(of: ",", with: "")
                       priceD = priceD.replacingOccurrences(of: "$", with: "")
                       priceD = priceD.replacingOccurrences(of: "US", with: "")
            let priceDD = formatter.number(from: priceD )
                       cell.lblPrice.text = "\(Int(priceDD ?? 0))"
            if product.site == "amzn.eu" || product.site == "a.co" {
                product.imgURL = product.imgURL?.replacingOccurrences(of: "\ndata:image/jpeg;base64,", with: "").replacingOccurrences(of: "\n\n\n\n\n\n\n\n", with: "")
                //let dataDecoded  = Data(base64Encoded: product.imgURL ?? "", options: .ignoreUnknownCharacters)!
                let url = URL(string: product.imgURL ?? "")
                if let urls = url {
                    if let data = try? Data(contentsOf: urls)
                    {
                        let image: UIImage? = UIImage(data: data)
                        cell.imgProduct.image = image
                    }
                }
                
            }else{
                let imgUrl = URL(string: product.imgURL ?? "")
                cell.imgProduct.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "noImage"), options: .highPriority, completed: nil)
            }
            
            
            if ((product.logoURL) != nil){
                let logoUrl = URL(string: product.logoURL ?? "")
                cell.imgCompany.sd_setImage(with: logoUrl, placeholderImage: UIImage(named: "noImage"), options: .highPriority, completed: nil)
            }
            else{
                cell.lblMerchent.text = ((self.firstPrd["merchantName"]) as? String) ?? "Others"
                cell.lblMerchent.isHidden = false
            }
            
            let priceTemp = product.price ?? "0"
            var priceS = product.price?.replacingOccurrences(of: "₹", with: "") ?? "1"
            priceS = priceS.replacingOccurrences(of: "Rs.", with: "")
            priceS = priceS.replacingOccurrences(of: "INR", with: "")
            priceS = priceS.replacingOccurrences(of: ",", with: "")
            priceS = priceS.replacingOccurrences(of: "$", with: "")
            priceS = priceS.replacingOccurrences(of: "US", with: "")
            
            let price = (priceS as NSString).doubleValue
            var priceV = 0.0
            priceV = (Double(product.percentage ?? 0) / 100) * price
            let priceN = (self.rewardP / 100) * priceV
//            if priceTemp.contains("₹"){
//                arrayProducts[indexPath.row].rewards = "₹\(String(format: "%.2f", priceN))"
//            }
//            else if priceTemp.contains("$"){
//                arrayProducts[indexPath.row].rewards = "$\(String(format: "%.2f", priceN))"
//            }else{
//                if appDelegate?.loginUser?.country_code == "+91"{
//                    arrayProducts[indexPath.row].rewards = "₹\(String(format: "%.2f", priceN))"
//                }else{
//                    arrayProducts[indexPath.row].rewards = "$\(String(format: "%.2f", priceN))"
//                }
//            }
//            if (indexPath.row == 0){
//                if (product.price!.contains("₹")){
//                    arrayProducts[indexPath.row].rewards = "₹\(String(format: "%.2f", priceN))"
//                }
//            }
            if priceTemp.contains("₹"){
                           let rewardsD = formatter.number(from: "\(Int(priceN ))")
                           arrayProducts[indexPath.row].rewards = "₹\(rewardsD ?? 0)"
                       }
                       else if priceTemp.contains("$"){
                           let rewardsD = formatter.number(from: "\(Int(priceN ))")
                           arrayProducts[indexPath.row].rewards = "$\(rewardsD ?? 0)"
                          
                       }else{
                           if appDelegate?.loginUser?.country_code == "+91"{
                               let rewardsD = formatter.number(from: "\(Int(priceN ))")
                               arrayProducts[indexPath.row].rewards = "₹\(rewardsD ?? 0)"
                           }else{
                               let rewardsD = formatter.number(from: "\(Int(priceN ))")
                               arrayProducts[indexPath.row].rewards = "$\(rewardsD ?? 0)"
                           }
                       }
                       if (indexPath.row == 0){
                           if (product.price!.contains("₹")){
                               let rewardsD = formatter.number(from: "\(Int(priceN ))")
                               arrayProducts[indexPath.row].rewards = "₹\(rewardsD ?? 0)"
                           }
                       }
            cell.lblRewards.text =   arrayProducts[indexPath.row].rewards
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        heightProduct.constant = 40
        heightProduct1.constant = 40
        
        offer1View.isHidden = true
        offer2View.isHidden = true
        offerPopupViewHeightConstraints.constant = 320
        offerStackViewHeightConstraints.constant = 100
        btnProduct.isHidden = false
        btnProduct1.isHidden = false
        
        let product = arrayProducts[selectedRow]
        
        let url = product.url ?? ""
        
        if country == "india"{
            DispatchQueue.main.async {
                if indexPath.row == 0 {
                    let url = URL(string: self.shareURL)
                    self.webView.load(URLRequest(url: url!))
                }else {
                    let url = URL(string: url)
                    self.webView.load(URLRequest(url: url!))
                }
                self.viewReferNew!.isHidden = false
            }
        }else{
            viewRefer!.isHidden = false
        }
        selectedRow = indexPath.row
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func btnMoreHandler(sender:UIButton){
        sender.isSelected = !sender.isSelected
        
        if let cell = sender.superview?.superview?.superview as? ReferralCell{
            if sender.isSelected{
                cell.lblTitle.numberOfLines = 0
            }
            else{
                cell.lblTitle.numberOfLines = 2
            }
            cell.lblTitle.layoutIfNeeded()
        }
        tableRefer.reloadData()
    }
}

extension ReferralViewController : SFSafariViewControllerDelegate{
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    }
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
    }
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        print(URL)
    }
    
    func getHtmlParsingKeys(){
        
        APIRequest.shared().htmlParsingKeys { (response, error) in
            if let json = response as? [String : Any], let data = json[CJsonData] as? [[String : Any]] {
                
                self.arrayMKeys = data
                let found = self.arrayMKeys.map({$0["name"]})
                print("found-- ",found)
                self.loadParsing()
            }
        }
    }
    
}

