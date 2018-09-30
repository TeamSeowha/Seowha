//
//  SecondInitializeViewController.swift
//  seowha
//
//  Created by Jinsoo Heo on 28/09/2018.
//  Copyright © 2018 TeamSeowha. All rights reserved.
//

import UIKit

import Firebase

class SecondInitializeViewController: UIViewController {
    var db: Firestore!
    
    var nickname: String = ""
    var age: Int = 0;
    var sex: String = ""
    
    let interestsList: [String] = [
        "play",
        "musical",
        "classical",
        "concert",
        "festival",
        "exhibition",
        "event",
        "sport"
    ]
    
    @IBOutlet var activityButtons: [UIButton]!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()

        for activityButton in activityButtons {
            activityButton.setTitleColor(UIColor(rgb: 0xEF706A), for: .normal)
            activityButton.setTitleColor(UIColor.white, for: .selected)
            activityButton.layer.borderWidth = 2.0
            activityButton.layer.cornerRadius = 5.0
            activityButton.layer.borderColor = UIColor(rgb: 0xEF706A).cgColor
        }
        
        self.startButton.backgroundColor = UIColor(rgb: 0xEF706A)
        self.startButton.layer.borderWidth = 2.0
        self.startButton.layer.cornerRadius = 5.0
        self.startButton.layer.borderColor = UIColor(rgb: 0xEF706A).cgColor
    }
    
    @IBAction func activityButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            sender.backgroundColor = UIColor(rgb: 0xEF706A)
        } else {
            sender.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        var interests: [String] = []
        
        for i in 0 ..< activityButtons.count {
            if activityButtons[i].isSelected {
                interests.append(interestsList[i])
            }
        }
        
        db.collection("users").document(Auth.auth().currentUser!.uid).setData([
            "nickname": nickname,
            "age": age,
            "sex": sex,
            "interests": interests
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                
                self.goToMainView()
            }
        }
    }
    
    func goToMainView() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainView = storyBoard.instantiateViewController(withIdentifier: "MainView")
        self.present(mainView, animated: true, completion: nil)
    }
}
