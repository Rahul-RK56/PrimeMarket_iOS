//
//  RedeemViewController.swift
//  SMarket
//
//  Created by CIPL0668 on 23/10/20.
//  Copyright © 2020 Mind. All rights reserved.
//

import UIKit


class RedeemCell: UITableViewCell {
    
    let formatter = NumberFormatter()
    @IBOutlet weak var lblAmount : UILabel!
    @IBOutlet weak var lblValidity : UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var txtQty: UITextField!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class RedeemViewController: ParentViewController {
    let formatter = NumberFormatter()
    
    @IBOutlet weak var tableGift : UITableView!
    @IBOutlet weak var btnRedeem: UIButton!
    @IBOutlet weak var lblTotal: UILabel!
    
    var arrayList = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = "GIFT CARD"
        btnRedeem.layer.cornerRadius = 5.0
        btnRedeem.layer.masksToBounds = true
        
        getGiftList()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
//        lblTotal.text = "\(appDelegate!.currency)\(appDelegate?.loginUser?.refcash ?? "0")"
        let amountD = formatter.number(from: appDelegate?.loginUser?.refcash ?? "0")
                lblTotal.text = "\(appDelegate!.currency)\(Int(amountD ?? 0))"

    }
    func getGiftList(){
        
        APIRequest.shared().giftList() { (response, error) in
            if let json = response as? [String : Any], let data = json[CJsonData] as? [[String : Any]] {
                self.arrayList = data
                self.tableGift.reloadData()
            }
        }
    }
    @IBAction func redeemButtonHandler(){
        reedeemRefCase()
    }
    func reedeemRefCase()
    {
        
        var param = [String : Any]()
        var amt = 0
        var amtArray : [[String:String]] = []
        for i in 0 ..< arrayList.count {
            let cell = tableGift.cellForRow(at: IndexPath(row: i, section: 0)) as! RedeemCell
            let dict = arrayList[i]
            if (cell.txtQty.text! as NSString).integerValue > 0{
                var amount : [String:String] = [:]
                amount["gift_amount"] = cell.lblAmount.text
                amount["merchant_name"] = dict["name"] as? String
                amount["gift_quantity"] = cell.txtQty.text
                amount["gift_validity"] = dict["expiry_date"] as? String
                let tot = dict["amount"] as! Int * (cell.txtQty.text! as NSString).integerValue
                amt = amt + tot
                
                print(cell.lblAmount.text)
                
                amtArray.append(amount)
            }
        }
        if(amt == 0){
            self.showAlertView("Please add gift card", completion: nil)
            return
        }
        param["amount"] =  "\(amt)"
        param["gift_cards"] = amtArray
        
        APIRequest.shared().redeemRefCase(param) { (response, error) in
            if let json = response as? [String : Any], let meta = json[CJsonMeta] as? [String : Any] {
                
                if meta.valueForInt(key:CJsonStatus) == CStatusZero {
                    appDelegate?.loginUser?.refcash = meta.valueForString(key:"refcash")
                    appDelegate?.loginUser?.min_withdraw_amount = meta.valueForString(key:"min_withdraw_amount")
                    self.showAlertView(meta.valueForString(key: CJsonMessage)) { (action) in
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
                else {
                    self.showAlertView(meta.valueForString(key: CJsonMessage), completion: nil)
                }
            }
        }
    }
}
extension RedeemViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RedeemCell") as? RedeemCell{
            cell.selectionStyle = .none
            cell.btnPlus.addTarget(self, action: #selector(btnPlusHandler), for: .touchUpInside)
            cell.btnMinus.addTarget(self, action: #selector(btnMinusHandler), for: .touchUpInside)
            cell.btnPlus.tag = indexPath.row
            cell.btnMinus.tag = indexPath.row
            
            let dict = arrayList[indexPath.row]
           // cell.lblAmount.text = "\(appDelegate!.currency)\(String(describing: dict["amount"] as! Int))"
            cell.lblAmount.text = "\(String(describing: dict["amount"] as! Int))"
            cell.lblValidity.text = "\(dict["expiry_date"] as? String ?? "")"
            let imgUrl = URL(string: dict["logo"] as? String ?? "")
            
            cell.imgLogo.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "noImage"), options: .highPriority, completed: nil)
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    @objc func btnPlusHandler(sender:UIButton){
        
        if let cell = sender.superview?.superview?.superview?.superview as? RedeemCell{
            let qty = (cell.txtQty.text! as NSString).integerValue + 1
            cell.txtQty.text = "\(qty)"
            let dict = arrayList[sender.tag]
            let amt = dict["amount"] as! Int * qty
            cell.lblTotal.text = "Total : \(appDelegate!.currency)\(amt)"
        }
    }
    
    @objc func btnMinusHandler(sender:UIButton){
        if let cell = sender.superview?.superview?.superview?.superview as? RedeemCell{
            if (cell.txtQty.text! as NSString).integerValue > 0{
                let qty = (cell.txtQty.text! as NSString).integerValue - 1
                cell.txtQty.text = "\(qty)"
                let dict = arrayList[sender.tag]
                let amt = dict["amount"] as! Int * qty
                cell.lblTotal.text = "Total : \(appDelegate!.currency)\(amt)"
            }
        }
    }
}
