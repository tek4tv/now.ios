//
//  SceneDelegate.swift
//  NOW
//
//  Created by dovietduy on 1/29/21.
//

import UIKit
import FirebaseDynamicLinks
var isSharing = false
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool{
        print("I have received a URL through a custom scheme! \(url.absoluteString)")
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            self.handledIncomingDynamicLink(dynamicLink)
            return true
        } else {
            // Maybe handle Google or Facebook sign-in here
            return false
        }
    }
    func handledIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else {
            print("That's weird. My dynamic link object has no url")
            return
        }
        print("Your incoming link parameter is \(url.absoluteString)")
        
        guard dynamicLink.matchType == .unique || dynamicLink.matchType == .default else {
            print("Not a strong enough match type to continue")
            return
        }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return }
//        for queryItem in queryItems {
//            print("Parameter \(queryItem.name) has a value of \(queryItem.value ?? "")")
//        }
        if components.path == "/about" {
            if let id = queryItems.first(where: { $0.name == "id"}), let type = queryItems.first(where: {$0.name == "type"}) {
                switch type.value! {
                case "video":
                    guard let videoId = id.value else {return}
                    APIService.shared.getDetailVideo(privateKey: videoId) { data, error in
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
                case "music":
                    guard let videoId = id.value else {return}
                    APIService.shared.getDetailVideo(privateKey: videoId) { data, error in
                        if let data = data as? MediaModel{
                            if data.keyword != "" {
                                APIService.shared.getPlaylist(privateKey: data.keyword) { list, error in
                                    guard let list = list as? CategoryModel else {
                                        return
                                    }
                                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    guard let vc = storyboard.instantiateViewController(withIdentifier: MusicPlayerController.className) as? MusicPlayerController else {return}
                                    vc.item = data
                                    vc.listData = [data] + list.media.filter({$0.privateID != data.privateID})
                                    (self.window?.rootViewController as? UINavigationController)?.pushViewController(vc, animated: false)
                                }
                            } else {
                                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                guard let vc = storyboard.instantiateViewController(withIdentifier: MusicPlayerController.className) as? MusicPlayerController else {return}
                                vc.item = data
                                vc.listData = [data]
                                (self.window?.rootViewController as? UINavigationController)?.pushViewController(vc, animated: false)
                            }
                        }
                    }
                    break
                case "movie":
                    guard let videoId = id.value else {return}
                    APIService.shared.getDetailVideo(privateKey: videoId) { data, error in
                        if let data = data as? MediaModel{
                            if data.keyword != "" {
                                APIService.shared.getPlaylist(privateKey: data.keyword) { list, error in
                                    guard let list = list as? CategoryModel else {
                                        return
                                    }
                                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    guard let vc = storyboard.instantiateViewController(withIdentifier: VideoController.className) as? VideoController else {return}
                                    vc.item = data
                                    vc.listData = [data] + list.media.filter({$0.privateID != data.privateID})
                                    (self.window?.rootViewController as? UINavigationController)?.pushViewController(vc, animated: false)
                                }
                            } else {
                                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                guard let vc = storyboard.instantiateViewController(withIdentifier: VideoController.className) as? VideoController else {return}
                                vc.item = data
                                vc.listData = [data]
                                (self.window?.rootViewController as? UINavigationController)?.pushViewController(vc, animated: false)
                            }
                        }
                    }
                    break
                case "book":
                    guard let videoId = id.value else {return}
                    APIService.shared.getDetailVideo(privateKey: videoId) { data, error in
                        if let data = data as? MediaModel{
                            if data.keyword != "" {
                                APIService.shared.getPlaylist(privateKey: data.keyword) { list, error in
                                    guard let list = list as? CategoryModel else {
                                        return
                                    }
                                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    guard let vc = storyboard.instantiateViewController(withIdentifier: BookPlayerController.className) as? BookPlayerController else {return}
                                    vc.data = data
                                    if data.endTimecode != ""{
                                        
                                    }else {
                                        vc.isNovel = true
                                        vc.listData = [data] + list.media.filter({$0.privateID != data.privateID})
                                    }
                                    
                                    (self.window?.rootViewController as? UINavigationController)?.pushViewController(vc, animated: false)
                                }
                            } else {
                                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                guard let vc = storyboard.instantiateViewController(withIdentifier: BookPlayerController.className) as? BookPlayerController else {return}
                                vc.data = data
                                if data.endTimecode != ""{
                                    
                                }else {
                                    vc.isNovel = true
                                    vc.listData = [data]
                                }
                                (self.window?.rootViewController as? UINavigationController)?.pushViewController(vc, animated: false)
                            }
                        }
                    }
                    break
                case "news":
                    guard let url = id.value else {return}
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    guard let vc = storyboard.instantiateViewController(withIdentifier: ReadDetailWebviewController.className) as? ReadDetailWebviewController else {return}
                    vc.url = url
                    (self.window?.rootViewController as? UINavigationController)?.pushViewController(vc, animated: false)
                    break
                default:
                    break
                }
            }
        }
        
    }
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity){
        if let incomingURL = userActivity.webpageURL{
            print("Incoming URL is \(incomingURL)")
            let _ = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLink, error in
                guard error == nil else{
                    print("Found an error \(error!.localizedDescription)")
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handledIncomingDynamicLink(dynamicLink)
                }
            }
        }
    }
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        guard let url = Array(connectionOptions.userActivities).first?.webpageURL else {
            return
        }
        DynamicLinks.dynamicLinks().handleUniversalLink(url) { [self] dynamicLink, error in
            if error != nil {
                return
            }
            if let dynamicLink = dynamicLink {
                handledIncomingDynamicLink(dynamicLink)
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

