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
    
    var editingExistingMeme = false
    

    @IBOutlet weak var myImageView: UIImageView!


    override func viewDidLoad() {
        super.viewDidLoad()

        
        tabBarController?.tabBar.hidden = true

    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        //SET THE IMAGE
        let image = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[itemSelected].memedImage
        myImageView.image = image

    }
    
    

    @IBAction func edit(sender: UIBarButtonItem) {
        
        if let vc = storyboard!.instantiateViewControllerWithIdentifier("MemeEditViewControllerID") as? MemeEditViewController{
            presentViewController(vc, animated: true, completion: nil)
            
            vc.editingExistingMeme = true
            vc.itemSelected = itemSelected
                        
        }
        
    
        
    }


}
