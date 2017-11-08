//
//  AppDelegate.swift
//  WEAttendance
//
//  Created by Prasidha Timsina on 10/26/17.
//  Copyright © 2017 Prasidha Timsina. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate {

    var window: UIWindow?
    let beaconManager = ESTBeaconManager()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // ask the user to allow notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            print("notifications allowed? = \(granted)")
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name:"Main",bundle:nil)
        
        var vc: UIViewController
        
        
        
        if(UserDefaults.standard.value(forKey: "NetID") as? String) == nil{
            
            vc = storyboard.instantiateViewController(withIdentifier: "LoginID")
            
        }else{
            
            vc = storyboard.instantiateInitialViewController()!
            
        }
        
        self.window?.rootViewController = vc
        
        self.window?.makeKeyAndVisible()
        ESTConfig.setupAppID("weattendance-2lq", andAppToken: "a65fb0eb6418d444bc866aa8b5d44e15")
        
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        
        // set up the monitor regions
        loadRegions()
        self.beaconManager.startMonitoring(for: CLBeaconRegion(
            proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
            major: 45268, identifier: ""))
        
        return true
    }
    
    
    
    // set given an array of monitoringRegion to UserDefaults where key is "monitorRegions"
    func setRegion(regions: [MonitoringRegion]) {
        let regionsData = NSKeyedArchiver.archivedData(withRootObject: regions)
        UserDefaults.standard.set(regionsData, forKey: "monitorRegions")
    }
    
    // print out current monitoring region
    func loadRegions() {
        guard let RegionsData = UserDefaults.standard.object(forKey: "monitorRegions") as? NSData else {
            print("'monitorRegions' not found in UserDefaults")
            return
        }
        
        guard let regions = NSKeyedUnarchiver.unarchiveObject(with: RegionsData as Data) as? [MonitoringRegion] else {
            print("Could not unarchive from RegionsData")
            return
        }
        
        for region in regions {
            print("")
            print("date: \(region.date)")
        }
    }
    
    // return current monitoring region. if the region is not set, return empty array
    func getRegionsArray() -> Array<MonitoringRegion>{
        var regions: [MonitoringRegion] = []
        if(UserDefaults.standard.object(forKey: "monitorRegions") != nil){
            let RegionsData = UserDefaults.standard.object(forKey: "monitorRegions") as? NSData
            if(NSKeyedUnarchiver.unarchiveObject(with: RegionsData! as Data) != nil){
                regions = (NSKeyedUnarchiver.unarchiveObject(with: RegionsData! as Data) as? [MonitoringRegion])!
            }else{
                let regionsData = NSKeyedArchiver.archivedData(withRootObject: regions)
                UserDefaults.standard.set(regionsData, forKey: "monitorRegions")
            }
        }else{
            let regionsData = NSKeyedArchiver.archivedData(withRootObject: regions)
            UserDefaults.standard.set(regionsData, forKey: "monitorRegions")
        }
        return regions
    }
    
    
    
    func showNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(
            identifier: "BeaconNotification", content: content, trigger: nil)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    
    
    func beaconManager(_ manager: Any, didEnter region: CLBeaconRegion) {
        print("enter")
        showNotification(title: "Hello!", body: "You entered the range of a beacon!")
        
    }
    func beaconManager(_ manager: Any, didExitRegion region: CLBeaconRegion) {
        print("exit")
        showNotification(title: "GoodBye!", body: "You left the range of a beacon!")
    }
    func beaconManager(_ manager: Any, didDetermineInitialState state: ESTMonitoringState,
                       forBeaconWithIdentifier identifier: String) {
        // state codes: 0 = unknown, 1 = inside, 2 = outside
        print("didDetermineInitialState '\(state)' for beacon \(identifier)")
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
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

