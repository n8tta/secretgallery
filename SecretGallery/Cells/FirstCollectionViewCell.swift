//
//  FirstCollectionViewCell.swift
//  SecretGallery
//
//  Created by Natallia Valadzko on 16.02.21.
//

import UIKit

    //MARK: - Protocols
protocol FirstCollectionViewCellDelegate: AnyObject {
    func showAlert()
}

    //MARK: - Class
class FirstCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var plusButton: UIButton!
    
    //MARK: - Variables
    weak var delegate: FirstCollectionViewCellDelegate?

    //MARK: - Flow functions
    func configure(with object: FirstCell) {
        plusButton = object.plusButton
    }
    
    //MARK: - IBActions
    @IBAction func plusButtobPressed(_ sender: UIButton) {
        delegate?.showAlert()
    }
}
