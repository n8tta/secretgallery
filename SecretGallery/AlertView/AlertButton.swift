//
//  AlertButton.swift
//  SecretGallery
//
//  Created by Natallia Valadzko on 9.05.21.
//

import UIKit
//@IBDesignable
//MARK: - Class AlertButton
class AlertButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 15
    }
}
