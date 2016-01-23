//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by francisco Alcala on 1/17/16.
//  Copyright © 2016 ciscoalcala. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    @IBOutlet var myTableView: UITableView!
    
    var rowSelected = 0
    
    let cellIdentifier = "MemeTableViewCellReuseID"
    
    var memes = [Meme]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        
        myTableView.reloadData()
        
        tabBarController?.tabBar.hidden = false
        
        //check if the array is empty, if empty go directly to edit view controller
        if memes.count == 0 {
            addMeme(self)
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    
        let sentMeme = memes[indexPath.row]
        
        let memeTopText     = sentMeme.topText
        let memeBottomText  = sentMeme.bottomText
        let memedImage      = sentMeme.memedImage
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MemeTableViewCell
        
        cell.memeCellTopLabel.text      = memeTopText
        cell.memeCellBottomLabel.text   = memeBottomText
        cell.memeImageView.image        = memedImage
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rowSelected = indexPath.row
        performSegueWithIdentifier("ShowMemeDetailView", sender: self)
    }
    

    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            tableView.beginUpdates()
            
            // Delete the row from the data source
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            
            //recopy the current memes array
            memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
            tableView.endUpdates()
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        
        let vc = segue.destinationViewController as! MemeDetailViewController
        
        vc.itemSelected = rowSelected


    }
    
    
    // MARK: - IBActions
    @IBAction func addMeme(sender: AnyObject) {
        
        if let vc = storyboard?.instantiateViewControllerWithIdentifier("MemeEditViewControllerID"){
            presentViewController(vc, animated: true, completion: nil)
        }
    }

}
