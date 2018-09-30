//
//  ThirdViewController.swift
//  seowha
//
//  Created by Jinsoo Heo on 29/09/2018.
//  Copyright © 2018 TeamSeowha. All rights reserved.
//

import UIKit

import Firebase

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xEF706A),
            NSAttributedString.Key.font: UIFont(name: "YunTaemin", size: 40)!
        ]
        self.navigationController?.navigationBar.tintColor = UIColor(rgb: 0xEF706A)
        self.navigationController?.navigationBar.layer.shadowColor = UIColor(rgb: 0xCCCCCC).cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
        self.navigationController?.navigationBar.layer.shadowRadius = 2.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
        
//        let customTabBarItem: UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab4_profile_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "tab4_profile_on"))
//        self.tabBarItem = customTabBarItem
    }
    
    func goToSignInView() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signInView = storyBoard.instantiateViewController(withIdentifier: "SignInView")
        self.present(signInView, animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            goToSignInView()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
