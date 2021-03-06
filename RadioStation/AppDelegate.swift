//
//  AppDelegate.swift
//  RadioStation
//
//  Created by Keith Martin on 6/27/16.
//  Copyright © 2016 PubNub. All rights reserved.
//

import UIKit
import PubNub
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener {

    var window: UIWindow?
    lazy var client: PubNub = {
        let config = PNConfiguration(publishKey: "pub-c-632aa1ab-06a6-4a37-b6ab-a86d25e5a3e5", subscribeKey: "sub-c-d6d54c3e-3808-11e6-b83b-0619f8945a4f")
        let pub = PubNub.clientWithConfiguration(config)
        return pub
    }()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //Ask user for for Apple Music access
        SKCloudServiceController.requestAuthorization { (status) in
            if status == .Authorized {
                let controller = SKCloudServiceController()
                //Check if user is a Apple Music member
                controller.requestCapabilitiesWithCompletionHandler({ (capabilities, error) in
                    if error != nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.showAlert("Capabilites error", error: "You must be an Apple Music member to use this application")
                        })
                    }
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.showAlert("Denied", error: "User has denied access to Apple Music library")
                })
            }
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //Dialogue showing error
    func showAlert(title: String, error: String) {
        let alertController = UIAlertController(title: title, message: error, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
    }

}

