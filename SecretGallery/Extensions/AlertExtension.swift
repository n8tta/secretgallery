//
//  AlertExtension.swift
//  SecretGallery
//
//  Created by Natallia Valadzko on 29.01.21.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertUniversal(title: String, message: String, actionTitles:[String], actionStyle:[UIAlertAction.Style], actions:[((UIAlertAction) -> Void)?], vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: actionStyle[index], handler: actions[index])
            alert.addAction(action)
        }
        vc.present(alert, animated: true, completion: nil)
    }
}
