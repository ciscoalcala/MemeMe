//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by francisco Alcala on 1/17/16.
//  Copyright © 2016 ciscoalcala. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCollViewCellReuseID"

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var memes = [Meme]()
    
    var itemSelected = 0
    
    @IBOutlet var myCollectionView: UICollectionView!

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        
        let spacing : CGFloat = 2.0
        let dimensionX = (view.frame.size.width - 2.0 * spacing) / 3.0
        
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        
        flowLayout.itemSize = CGSizeMake(dimensionX, dimensionX)
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

    
    // MARK: - IBActions

    @IBAction func addMeme(sender: UIBarButtonItem) {
        
        if let vc = storyboard?.instantiateViewControllerWithIdentifier("MemeEditViewControllerID"){
            presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func editTableView(sender: UIBarButtonItem) {
        
    }

}
