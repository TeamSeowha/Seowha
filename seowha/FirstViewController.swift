//
//  FirstViewController.swift
//  seowha
//
//  Created by Jinsoo Heo on 20/09/2018.
//  Copyright © 2018 TeamSeowha. All rights reserved.
//

import UIKit

import Firebase

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func signOutButton(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let signInView = storyBoard.instantiateViewController(withIdentifier: "SignInView")
            
            self.present(signInView, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}

