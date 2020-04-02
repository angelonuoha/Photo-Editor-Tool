//
//  MemeDetailViewController.swift
//  MemeMe2.0
//
//  Created by Angel Onuoha on 12/11/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    @IBOutlet weak var memeDetail: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeDetail.image = meme.memedImage
    }
    
    
}
