//
//  AppDelegate.swift
//  Todoey
//
//  Created by Wan Ching on 16/04/2018.
//  Copyright © 2018 Wan Ching. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // find plist in /Users/wanching/Library/Developer/CoreSimulator/Devices/FF0EC51A-BF6F-40E5-AC5F-9C00B4BA5F42/data/Containers/Data/Application/BCB01355-6938-4A59-A12A-52DB4F246750/Library/Preferences
        print("PList directory")
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        // view Realm Database
        print("\nRealm directory")
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            let realm = try Realm()
        } catch {
            print("error in intializing realm \(error)")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {

        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    // lazy variable is executed only when it is needed, benefit to memory usage
    lazy var persistentContainer: NSPersistentContainer = {
        
        // create a container where our data is going to be saved, is like a SQL database
        let container = NSPersistentContainer(name: "DataModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    // Save all data before the apps is terminated
    func saveContext () {
        
        // context is like staging area in Git, saving data in a temporary storage before commit it
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

