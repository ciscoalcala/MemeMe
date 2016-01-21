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

        // Do any additional setup after loading the view.
        
        tabBarController?.tabBar.hidden = true
        
        //GET A COPY OF THE ARRAY IN APP DELEGATE
        var memes: [Meme] {
            return(UIApplication.sharedApplication().delegate as! AppDelegate).memes
        }
        
        //SET THE IMAGE
        let image = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[itemSelected].memedImage
        myImageView.image = image
        
        print("")
        print("Detail View----------")
        print(image)
        print("")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
