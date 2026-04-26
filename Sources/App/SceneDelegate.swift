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
        
        let label = UILabel(frame: vc.view.bounds)
        label.text = "FAKECHAT IS RUNNING!"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 48, weight: .bold)
        label.textColor = .white
        vc.view.addSubview(label)
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}