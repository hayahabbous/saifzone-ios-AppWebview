//
//  UICheckBox.swift
//  TouchIDdemo
//
//  Created by macbook pro on 1/4/18.
//  Copyright © 2018 Datacellme. All rights reserved.
//

import UIKit
class UICheckBox : UIButton{
    let checkedImage = UIImage(named: "check_box_checked")! as UIImage
    let uncheckedImage = UIImage(named: "check_box_unchecked")! as UIImage
    var isChecked : Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
