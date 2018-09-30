//
//  EmailSignInViewController.swift
//  seowha
//
//  Created by Jinsoo Heo on 27/09/2018.
//  Copyright © 2018 TeamSeowha. All rights reserved.
//

import UIKit

import Firebase

class EmailSignInViewController: UIViewController, UITextFieldDelegate {
    var db: Firestore!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.emailTextField.addBorderBottom(height: 1.5, color: UIColor.white)
        self.passwordTextField.addBorderBottom(height: 1.5, color: UIColor.white)
        
        self.emailTextField.attributedPlaceholder =
            NSAttributedString(string: "이메일", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        self.passwordTextField.attributedPlaceholder =
            NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        self.emailTextField.keyboardType = UIKeyboardType.emailAddress
        
        self.signInButton.layer.borderWidth = 2.0
        self.signInButton.layer.cornerRadius = 5.0
        self.signInButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.emailTextField.becomeFirstResponder()
    }
    
    @IBAction func signInButton(_ sender: UIButton) {
        signIn()
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(self.emailTextField) {
            self.passwordTextField.becomeFirstResponder()
        } else if textField.isEqual(self.passwordTextField) {
            self.passwordTextField.resignFirstResponder()
            signIn()
        }
        
        return true
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func signIn() {
        if let email = emailTextField.text, !email.isEmpty {
            if let password = passwordTextField.text, !password.isEmpty {
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if let error = error {
                        print("Login error: \(error.localizedDescription)")
                        
                        self.showAlert(title: "로그인 오류", message: error.localizedDescription)
                        
                        return
                    }
                    
                    // User is signed in
                    // [START get_document]
                    let docRef = self.db.collection("users").document(Auth.auth().currentUser!.uid)
                    
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            self.goToMainView()
                        } else {
                            // Document does not exist
                            self.goToInitializeView()
                        }
                    }
                    // [END get_document]
                }
            } else {
                showAlert(title: "로그인 오류", message: "비밀번호를 입력하세요")
            }
        } else {
            showAlert(title: "로그인 오류", message: "이메일을 입력하세요")
        }
    }
    
    func goToInitializeView() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initializeView = storyBoard.instantiateViewController(withIdentifier: "InitializeView")
        self.present(initializeView, animated: true, completion: nil)
    }
    
    func goToMainView() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainView = storyBoard.instantiateViewController(withIdentifier: "MainView")
        self.present(mainView, animated: true, completion: nil)
    }
}
