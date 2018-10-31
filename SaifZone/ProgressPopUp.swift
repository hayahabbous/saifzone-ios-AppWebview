//
//  ProgressPopUp.swift
//  SAIF Zone
//
//  Created by macbook pro on 2/13/18.
//  Copyright © 2018 mai malash. All rights reserved.
//

import UIKit
class ProgressPopUp : UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    var images: [UIImage]!
    var loading_1: UIImage!
    var loading_2: UIImage!
    var animatedImage: UIImage!
    var loading_3: UIImage!
    override func viewDidLoad() {
        loading_1 = UIImage(named: "saif_zone_01")
        loading_2 = UIImage(named: "saif_zone_02")
        loading_3 = UIImage(named: "saif_zone_03")
        images = [loading_1, loading_2, loading_3]
        animatedImage = UIImage.animatedImage(with: images, duration: 1.0)
        imageView.image = animatedImage
    }
    
    
}
