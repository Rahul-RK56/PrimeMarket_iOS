//
//  CustomPickerView.swift
//  Fairswap
//
//  Created by Mac-00014 on 06/07/18.
//  Copyright © 2018 FAIRSWAP. All rights reserved.
//

import UIKit

class CustomPickerView: UIView {

    @IBOutlet var imgView : UIImageView!
    @IBOutlet var lblTitle : UILabel!
    @IBOutlet var lblSingalTitle : UILabel!
    
        
    func  initCustomPickerView() -> CustomPickerView? {
        
        guard let pickerView = CustomPickerView.viewFromXib as? CustomPickerView else { return nil}
        
        pickerView.CViewSetHeight(height: 50)
        pickerView.CViewSetWidth(width: CScreenWidth)
        
        return pickerView
    }

}
