//
//  PaysyApp.swift
//  Paysy
//
//  Created by Anıl Demirci on 12.04.2022.
//

import SwiftUI
import Firebase
import OneSignal

@main
struct PaysyApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        FirebaseApp.configure()
    }
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }.onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
              print("App is active")
            case .inactive:
              print("App is inactive")
            case .background:
              print("App is in background")
            @unknown default:
              print("Oh - interesting: I received an unexpected new value.")
            }
          }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       // Remove this method to stop OneSignal Debugging
       OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
        
       OneSignal.initWithLaunchOptions(launchOptions)
       OneSignal.setAppId("30b5b507-d946-4f3b-8868-1e106cb8c5a9")
        
       OneSignal.promptForPushNotifications(userResponse: { accepted in
         print("User accepted notification: \(accepted)")
       })
      
      // Set your customer userId
      // OneSignal.setExternalUserId("userId")
      
       return true
    }
}
