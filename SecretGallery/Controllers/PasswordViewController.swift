//
//  PasswordViewController.swift
//  SecretGallery
//
//  Created by Natallia Valadzko on 27.01.21.
//

import UIKit
import SwiftyKeychainKit

    //MARK: - ViewController
class PasswordViewController: UIViewController {
    
    // MARK: - Costants
    private let passwordField = UITextField()
    private let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let keychain = Keychain(service: "com.projects.SecretGallery")
    private let accessTokenKey = KeychainKey<String>(key: "accessToken")
    
    // MARK: - Variables
    private var alertView: AlertView!
    
    // MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVisualEffectView()
        
        do {
            try keychain.set("123", for: accessTokenKey)
        } catch let error {
            debugPrint(error)
        }
        
        hideKeyboard()
        passwordField.delegate = self
    }
    
    // MARK: - IBActions
    @IBAction func showAlertButtonPressed(_ sender: UIButton) {
        setAlert()
        startAnimation()
    }
    
    // MARK: - Flow functions
    private func setAlert() {
        alertView = AlertView.loadFromNib()
        alertView.center = view.center
        alertView.set(title: "Hello", message: "This gallery is password protected. Please enter your password to continue.", passwordField: passwordField, leftButtonTitle: "Cancel", rightButtonTitle: "Submit")
        alertView.passwordField.placeholder = "Enter your password"
        alertView.passwordField.clearButtonMode = .unlessEditing
        alertView.passwordField.isSecureTextEntry = true
        alertView.leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchUpInside)
        alertView.rightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchUpInside)
        view.addSubview(alertView)
    }
    
    private func setupVisualEffectView() {
        view.addSubview(visualEffectView)
        visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.alpha = 0
    }
    
    private func startAnimation() {
        alertView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 1
            self.alertView.alpha = 1
        }
    }
    
    private func stopAnimation() {
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.alpha = 0
            self.alertView.alpha = 0
        } completion: { (_) in
            self.alertView.removeFromSuperview()
        }
    }
    
    private func removeAlertView() {
        UIView.animate(withDuration: 0.4) {
            self.alertView.alpha = 0
        } completion: { (_) in
            self.alertView.removeFromSuperview()
        }
    }
    
    private func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func rightButtonPressed(_ sender: AlertButton) {
        guard let passwordFromAlert = alertView.passwordField else { return }
        
        guard let password = try? self.keychain.get(accessTokenKey) else {return}
        if let currentPassword = passwordFromAlert.text {
            if currentPassword == password {
                guard let controller = storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController else {
                    return
                }
                navigationController?.pushViewController(controller, animated: true)
                stopAnimation()
            } else {
                removeAlertView()
                showAlertUniversal(title: "Password is incorrect!",
                                   message: "Please enter correct password to continue.",
                                   actionTitles: ["Cancel", "Try again"],
                                   actionStyle: [.cancel, .default],
                                   actions: [nil, { (_) in
                                    self.setAlert()
                                    self.startAnimation()
                                   }],
                                   vc: self)
            }
        }
        registerForKeyboardNotifications()
    }
    
    @objc func leftButtonPressed() {
        stopAnimation()
    }
    
    //MARK: - Keyboard Setup
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    @IBAction private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        else { return }
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

    //MARK: - Extensions
extension PasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

