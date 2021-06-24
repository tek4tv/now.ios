//
//  AppDelegate.swift
//  NOW
//
//  Created by dovietduy on 1/29/21.
//

import UIKit
import Firebase
import Sentry
import UserNotifications
//import GoogleMobileAds
@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var myOrientation: UIInterfaceOrientationMask = .portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return myOrientation
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Messaging.messaging().subscribe(toTopic: "all") { error in
          print("Subscribed to weather topic")
        }
        NetworkMonitor.shared.startMonitoring()
        SentrySDK.start { options in
            options.dsn = "https://6b04af248940407bba9beac433db93ff@sentry.admon.com.vn/8"
            options.debug = true // Enabled debug when first installing is always helpful
        }
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 12 * scaleW)!], for: .normal)
//        GADMobileAds.sharedInstance().start(completionHandler: nil)
        FirebaseApp.configure() // gọi hàm để cấu hình 1 app Firebase mặc định
        Messaging.messaging().delegate = self //Nhận các message từ FirebaseMessaging
        configApplePush(application) // đăng ký nhận push.
        return true
    }

    func configApplePush(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()

//        if Messaging.messaging().fcmToken != nil {
////            print("FCM token: \(token)")
//        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("Firebase registration token: \(String(describing: fcmToken))")

        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        //Nhận được fcmToken,lưu lại và gửi lên back-end khi làm app thực tế
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print(response.notification.request.content.userInfo)
        let privateID = response.notification.request.content.userInfo["privateid"] as! String
        let privateKey = response.notification.request.content.userInfo["privatekey"] as! String
//        print(privateID)
        isMessaging = true
        APIService.shared.getPlaylist(privateKey: privateKey) { (data, error) in
            if let data = data as? CategoryModel{
                news = data
                APIService.shared.getDetailVideo(privateKey: privateID) { (media, error) in
                    if let media = media as? MediaModel{
                        news.media.insert(media, at: 0)
                        NotificationCenter.default.post(name: NSNotification.Name("HomeOpenVideo"), object: nil)
                    }
                }
            }
        }
    }
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

