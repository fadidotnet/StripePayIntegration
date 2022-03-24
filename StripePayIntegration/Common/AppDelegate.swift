//
//  AppDelegate.swift
//  StripePayIntegration
//
//  Created by Hafiz Fahad Hassan on 22/03/2022.
//

import UIKit
import Stripe
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Stripe Configuration
        Thread.sleep(forTimeInterval: 3)
        Stripe.setDefaultPublishableKey("")
        return true
    }
}

