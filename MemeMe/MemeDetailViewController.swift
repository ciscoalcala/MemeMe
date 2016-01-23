//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by francisco Alcala on 1/17/16.
//  Copyright © 2016 ciscoalcala. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var itemSelected = 0
    

    @IBOutlet weak var myImageView: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()

        
        tabBarController?.tabBar.hidden = true
        
        
        //SET THE IMAGE
        let image = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[itemSelected].memedImage
        myImageView.image = image

    }



}
