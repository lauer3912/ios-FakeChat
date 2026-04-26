import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        // RED BACKGROUND FOR DEBUG - REMOVE LATER
        window?.backgroundColor = .systemRed
        
        let vc = UIViewController()
        vc.view.backgroundColor = .systemBlue
        vc.view.addSubview(UILabel(frame: vc.view.bounds))
        vc.view.subviews.last?.text = "FAKECHAT IS RUNNING!"
        vc.view.subviews.last?.textAlignment = .center
        vc.view.subviews.last?.font = .systemFont(ofSize: 48, weight: .bold)
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}