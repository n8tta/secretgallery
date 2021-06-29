//
//  NibExtension.swift
//  SecretGallery
//
//  Created by Natallia Valadzko on 9.05.21.
//

import Foundation
import UIKit

//MARK: - NibExtension
extension UIView {
    class func loadFromNib<T: UIView>() -> T? {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as? T
    }
}

