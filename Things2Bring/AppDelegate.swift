//
//  AppDelegate.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/13/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //MARK: Parse
       
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("K7WZ7dbviyLC0ysdtBJ1pXOyHCnEKLjLURXY2cCF",
            clientKey: "u1P5rEmhYCuEREss6ekjWh6Zn2m0ZAHoBNHBaRfJ")
        
        //Registering Sublclasses
        Event.registerSubclass()
        Things2Bring.Guest.registerSubclass()
        
        //Login
        
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            var rootViewController = self.window!.rootViewController
            var storyboard = UIStoryboard(name: "Main", bundle: nil)
            var initialViewController = storyboard.instantiateViewControllerWithIdentifier("NavController") as! UINavigationController
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        } else {
            println("Hello")
        }
        
//        PFUser.logInWithUsername("Test", password: "test")
        
        if let user = PFUser.currentUser() {
            println("Log in successful")
        } else {
            println("No logged in user :(")
        }

        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        if url.host == "Event"{
            if let user = PFUser.currentUser() {
                var rootViewController = self.window!.rootViewController
                var storyboard = UIStoryboard(name: "Main", bundle: nil)
                var initialViewController = storyboard.instantiateViewControllerWithIdentifier("NavCont") as! UINavigationController
                var EventController = initialViewController.topViewController as! EventViewController
                EventController.openbylink = true
                EventController.eventId = dropFirst(url.path!)
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
                return true
            } else {
                var rootViewController = self.window!.rootViewController as! LoginViewController
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                rootViewController.invitationlink = true
                rootViewController.eventId = dropFirst(url.path!)
                return true
            }
        }else{
            return false
        }
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    


}

