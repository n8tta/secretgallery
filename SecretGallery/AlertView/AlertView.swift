//
//  AlertView.swift
//  SecretGallery
//
//  Created by Natallia Valadzko on 9.05.21.
//

import UIKit

//MARK: - Class AlertView
class AlertView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var leftButton: AlertButton!
    @IBOutlet weak var rightButton: AlertButton!
    
    //MARK: - Flow function
    func set(title: String, message: String, passwordField: UITextField, leftButtonTitle: String, rightButtonTitle: String) {
        titleLabel.text = title
        messageLabel.text = message
        leftButton.setTitle(leftButtonTitle, for: .normal)
        rightButton.setTitle(rightButtonTitle, for: .normal)
    }
}
