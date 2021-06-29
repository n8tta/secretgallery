//
//  GalleryViewController.swift
//  SecretGallery
//
//  Created by Natallia Valadzko on 3.02.21.
//

import UIKit

    //MARK: - Enum
enum directionChanging {
    case rightToCenter
    case centerToLeft
}

    //MARK: - GalleryViewController
class GalleryViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var bottomViewConstraint: NSLayoutConstraint!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraintSafe: NSLayoutConstraint!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var favoriteButton: UIButton!
    
    //MARK: - Constants
    private let rightImageView = UIImageView()
    private let leftImageView = UIImageView()
    private let interval = 1.0
    
    //MARK: - Variables
    private var images = [Image]()
    private var index = 0
    
    //MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
    
        addSwipeGestureRecognizer()
        captionField.delegate = self
        registerForKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addCentralImage()
    }
    
    //MARK: - IBActions
    @IBAction func getBackButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        addToFavorite()
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        showAlert()
    }

    //MARK: - Flow functions
    private func addCentralImage() {
        images = ImageItemManager.shared.loadImageItem()
        if let imageItem = images[index].image {
            imageView.image = FilesManager.shared.loadImage(fileName: imageItem)
        }
        if let captionItem = images[index].caption {
            captionField.text = captionItem
        }
        checkFavorite()
    }
    
    private func createRightImage() {
        index += 1
        if index > images.count - 1 {
            index = images.startIndex
        }
        rightImageView.frame = CGRect(x: view.frame.width,
                                      y: topConstraint.constant + topConstraintSafe.constant,
                                      width: imageView.frame.width,
                                      height: imageView.frame.height)
        
        if let imageItem = images[index].image {
            rightImageView.image = FilesManager.shared.loadImage(fileName: imageItem)
        }
        view.addSubview(rightImageView)
    }
    
    private func createLeftImage() {
        leftImageView.frame = CGRect(x: (view.frame.width - imageView.frame.width) / 2,
                                     y: topConstraint.constant + topConstraintSafe.constant,
                                     width: imageView.frame.width,
                                     height: imageView.frame.height)
        
        if let imageItem = images[index].image {
            leftImageView.image = FilesManager.shared.loadImage(fileName: imageItem)
        }
        view.addSubview(leftImageView)
    }
    
    private func changeDirection(direction: directionChanging) {
        switch direction {
        case .rightToCenter:
            createRightImage()
        case .centerToLeft:
            createLeftImage()
        }
    }
    
    @objc private func changeImage(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            swipeLeft()
        case .right:
            swipeRight()
        default:
            break
        }
    }
    
    private func swipeLeft() {
        changeDirection(direction: .centerToLeft)
        index -= 1
        if index < 0 {
            index = images.count - 1
        }
        if let imageItem = images[index].image {
            imageView.image = FilesManager.shared.loadImage(fileName: imageItem)
        }
        UIView.animate(withDuration: interval) {
            self.leftImageView.frame.origin.x = -self.view.frame.width
        } completion: { (_) in
            if let imageItem = self.images[self.index].image {
                self.imageView.image = FilesManager.shared.loadImage(fileName: imageItem)
            }
            if let captionItem = self.images[self.index].caption {
                self.captionField.text = captionItem
            } else {
                self.captionField.text = nil
            }
            self.checkFavorite()
            self.leftImageView.removeFromSuperview()
        }
    }

    private func swipeRight() {
        changeDirection(direction: .rightToCenter)
        UIView.animate(withDuration: interval) {
            self.rightImageView.frame.origin.x = CGFloat(Int((self.view.frame.width - CGFloat(self.rightImageView.frame.width))) / 2)
        } completion: { (_) in
            if let imageItem = self.images[self.index].image {
                self.imageView.image = FilesManager.shared.loadImage(fileName: imageItem)
            }
            if let captionItem = self.images[self.index].caption {
                self.captionField.text = captionItem
            } else {
                self.captionField.text = nil
            }
            self.checkFavorite()
            self.rightImageView.removeFromSuperview()
        }
    }
    
    private func addSwipeGestureRecognizer() {
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(changeImage(_:)))
        leftRecognizer.direction = .left
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(leftRecognizer)
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(changeImage(_:)))
        rightRecognizer.direction = .right
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(rightRecognizer)
    }
    
    private func addCaption() {
        if let userCaption = captionField.text {
            ImageItemManager.shared.saveCaption(image: images[index], caption: userCaption)
            images[index].caption = userCaption
        }
    }
    
    private func checkFavorite() {
        if images[index].isFavorite == true {
            favoriteButton.isSelected = true
            favoriteButton.setImage(UIImage(named: "bigheartfilled"), for: .normal)
        } else {
            favoriteButton.isSelected = false
            favoriteButton.setImage(UIImage(named : "bigheart"), for: .normal)
        }
    }
    
    private func addToFavorite() {
        if images[index].isFavorite == true {
            images[index].isFavorite = false
            favoriteButton.isSelected = false
            favoriteButton.setImage(UIImage(named : "bigheart"), for: .normal)
            ImageItemManager.shared.saveFavorite(image: images[index], isFavorite: false)
            images[index].isFavorite = false
            print("Image was removed from Favorites")
        } else {
            images[index].isFavorite = true
            favoriteButton.isSelected = true
            favoriteButton.setImage(UIImage(named: "bigheartfilled"), for: .normal)
            ImageItemManager.shared.saveFavorite(image: images[index], isFavorite: true)
            images[index].isFavorite = true
            print("Image was added to Favorites")
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete Image", style: .destructive, handler: { (_) in
            self.deleteImage()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteImage() {
        ImageItemManager.shared.deleteImage(image: images[index], index: index)
        navigationController?.popViewController(animated: true)
    }
   
    //MARK: - Keyboard Setup
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    @IBAction private func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if notification.name == UIResponder.keyboardWillHideNotification {
            bottomViewConstraint.constant = 0
        } else {
            bottomViewConstraint.constant = -keyboardScreenEndFrame.height - 30
        }
        view.needsUpdateConstraints()
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

    //MARK: - Extensions
extension GalleryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        addCaption()
        return true
    }
}

