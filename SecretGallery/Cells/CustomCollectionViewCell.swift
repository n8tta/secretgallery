//
//  CustomCollectionViewCell.swift
//  SecretGallery
//
//  Created by Natallia Valadzko on 16.02.21.
//

import UIKit
    
    //MARK: - Protocols
protocol CustomCollectionViewCellDelegate: AnyObject {
    func goToSlider(for cell: CustomCollectionViewCell)
}
    
    //MARK: - Protocols
class CustomCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Variables
    weak var delegate: CustomCollectionViewCellDelegate?
    
    //MARK: - Flow functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    func configure(with object: Image) {
        if let imageName = object.image {
            if let imageInCell = FilesManager.shared.loadImage(fileName: imageName) {
                imageView.image = imageInCell
            }
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        delegate?.goToSlider(for: self)
    }
}
