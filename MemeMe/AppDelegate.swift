//
//  AppDelegate.swift
//  MemeMe
//
//  Created by francisco Alcala on 1/16/16.
//  Copyright © 2016 ciscoalcala. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //make and array of Memes
    var memes = [Meme]()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.sharedApplication().statusBarHidden = true

        return true
    }

}

