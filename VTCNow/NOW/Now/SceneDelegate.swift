//
//  SceneDelegate.swift
//  NOW
//
//  Created by dovietduy on 1/29/21.
//

import UIKit

var isSharing = false
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url.absoluteString{
            let arraySplit = url.split(separator: "=")
            if arraySplit.count >= 2 {
                let privateID = arraySplit[1].description
                APIService.shared.getDetailVideo(privateKey: privateID) { data, error in
                    if let data = data as? MediaModel{
                        if data.keyword != "" {
                            APIService.shared.getPlaylist(privateKey: data.keyword) { list, error in
                                guard let list = list as? CategoryModel else {
                                    return
                                }
                                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                guard let vc = storyboard.instantiateViewController(withIdentifier: HighLight2Controller.className) as? HighLight2Controller else {return}
                                news = CategoryModel()
                                news.media = [data] + list.media.filter({$0.privateID != data.privateID})
                                NotificationCenter.default.post(name: NSNotification.Name("share"), object: nil)
                                (self.window?.rootViewController as? UINavigationController)?.pushViewController(vc, animated: false)
                            }
                        } else {
                            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            guard let vc = storyboard.instantiateViewController(withIdentifier: HighLight2Controller.className) as? HighLight2Controller else {return}
                            news = CategoryModel()
                            news.media = [data]
                            (self.window?.rootViewController as? UINavigationController)?.pushViewController(vc, animated: false)
                        }
                    }
                }
            }
        }
    }
//    func handledIncomingDynamicLink(_ dynamicLink: DynamicLink) {
//        guard let url = dynamicLink.url?.absoluteString else {
//            print("That's weird. My dynamic link object has no url")
//            return
//        }
//        print("Your incoming link parameter is \(url)")
//
//        guard dynamicLink.matchType == .unique || dynamicLink.matchType == .default else {
//            print("Not a strong enough match type to continue")
//            return
//        }
//        let arraySplit = url.split(separator: "/")
//        if arraySplit.count >= 5 {
//            let arraySplit5 = arraySplit[4].split(separator: ".")
//            if arraySplit5.count != 0{
//
//                let privateID = arraySplit5[0].description
//                APIService.shared.getDetailVideo(privateKey: privateID) { data, error in
//                    if let data = data as? MediaModel{
//                        if data.keyword != "" {
//                            APIService.shared.getPlaylist(privateKey: data.keyword) { list, error in
//                                guard let list = list as? CategoryModel else {
//                                    return
//                                }
//                                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                                guard let vc = storyboard.instantiateViewController(withIdentifier: HighLight2Controller.className) as? HighLight2Controller else {return}
//                                news = CategoryModel()
//                                news.media = [data] + list.media.filter({$0.privateID != data.privateID})
//                                NotificationCenter.default.post(name: NSNotification.Name("share"), object: nil)
//                                (self.window?.rootViewController as? UINavigationController)?.pushViewController(vc, animated: false)
//                            }
//                        } else {
//                            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                            guard let vc = storyboard.instantiateViewController(withIdentifier: HighLight2Controller.className) as? HighLight2Controller else {return}
//                            news = CategoryModel()
//                            news.media = [data]
//                            (self.window?.rootViewController as? UINavigationController)?.pushViewController(vc, animated: false)
//                        }
//                    }
//                }
//            }
//        }
//
//
//    }
//    func scene(_ scene: UIScene, continue userActivity: NSUserActivity){
//        if let incomingURL = userActivity.webpageURL{
//            print("Incoming URL is \(incomingURL)")
//            let _ = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLink, error in
//                guard error == nil else{
//                    print("Found an error \(error!.localizedDescription)")
//                    return
//                }
//                if let dynamicLink = dynamicLink {
//                    self.handledIncomingDynamicLink(dynamicLink)
//                }
//            }
//        }
//    }
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let url = connectionOptions.urlContexts.first?.url.absoluteString else {
            return
        }
        isMessaging = true
        let arraySplit = url.split(separator: "=")
        if arraySplit.count >= 2 {
            let privateID = arraySplit[1].description
            APIService.shared.getDetailVideo(privateKey: privateID) { data, error in
                if let data = data as? MediaModel{
                    if data.keyword != "" {
                        APIService.shared.getPlaylist(privateKey: data.keyword) { list, error in
                            guard let list = list as? CategoryModel else {
                                return
                            }
//                            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                            guard let vc = storyboard.instantiateViewController(withIdentifier: HighLight2Controller.className) as? HighLight2Controller else {return}
                            news = CategoryModel()
                            news.media = [data] + list.media.filter({$0.privateID != data.privateID})
//                            NotificationCenter.default.post(name: NSNotification.Name("share"), object: nil)
//                            (self.window?.rootViewController as? UINavigationController)?.pushViewController(vc, animated: false)
                        }
                    } else {
//                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                        guard let vc = storyboard.instantiateViewController(withIdentifier: HighLight2Controller.className) as? HighLight2Controller else {return}
                        news = CategoryModel()
                        news.media = [data]
//                        (self.window?.rootViewController as? UINavigationController)?.pushViewController(vc, animated: false)
                    }
                }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

