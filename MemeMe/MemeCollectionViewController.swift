//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by francisco Alcala on 1/17/16.
//  Copyright © 2016 ciscoalcala. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCollViewCellReuseID"

class MemeCollectionViewController: UICollectionViewController {
    var memes = [Meme]()
    
    var itemSelected = 0
    
    @IBOutlet var myCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
        myCollectionView.reloadData()
        
        tabBarController?.tabBar.hidden = false

        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        let vc = segue.destinationViewController as! MemeDetailViewController
        
        vc.itemSelected = itemSelected
        print(" ")
        print("prepare for segue")
        print("this is the row selected: \(itemSelected)")
        print("this is what vc.itemselected: \(vc.itemSelected)")
        print(" ")
        
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
    
        // Configure the cell
        
        let sentMeme = memes[indexPath.row]
        
        let memedImage      = sentMeme.memedImage
        
        cell.myImageView.image        = memedImage
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        itemSelected = indexPath.item
        performSegueWithIdentifier("ShowMemeDetailView", sender: self)

    
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    // MARK: - IBActions

    @IBAction func addMeme(sender: UIBarButtonItem) {
        
        if let vc = storyboard?.instantiateViewControllerWithIdentifier("MemeEditViewControllerID"){
            presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func editTableView(sender: UIBarButtonItem) {
        
    }

}
