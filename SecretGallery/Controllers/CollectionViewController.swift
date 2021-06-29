//
//  CollectionViewController.swift
//  SecretGallery
//
//  Created by Natallia Valadzko on 30.01.21.
//

import UIKit

    //MARK: - CollectionViewController
class CollectionViewController: UIViewController, FirstCollectionViewCellDelegate, CustomCollectionViewCellDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Variables
    private var images = [Image]()
    private var firstCellArray = [FirstCell()]
    
    //MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        images = ImageItemManager.shared.loadImageItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        images = ImageItemManager.shared.loadImageItem()
        collectionView.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func getBackButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Flow functions
    private func performLibraryImagePicker() {
        let libraryImagePicker = UIImagePickerController()
        libraryImagePicker.delegate = self
        libraryImagePicker.modalPresentationStyle = .currentContext
        libraryImagePicker.allowsEditing = false
        libraryImagePicker.sourceType = .photoLibrary
        present(libraryImagePicker, animated: true, completion: nil)
    }
    
    private func performCameraImagePicker() {
        let cameraImagePicker = UIImagePickerController()
        cameraImagePicker.delegate = self
        cameraImagePicker.modalPresentationStyle = .currentContext
        cameraImagePicker.allowsEditing = false
        cameraImagePicker.sourceType = .camera
        present(cameraImagePicker, animated: true, completion: nil)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Choose From Library", style: .default, handler: { (_) in
            self.performLibraryImagePicker()
        }))
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { (_) in
            self.performCameraImagePicker()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToSlider(for cell: CustomCollectionViewCell) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "GalleryViewController") as? GalleryViewController else {
            return
        }
        navigationController?.pushViewController(controller, animated: true)
    }
}

    //MARK: - Extensions
extension CollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            let fileName = FilesManager.shared.saveImage(image: pickedImage)
            let newImage = Image(image: fileName, caption: nil, isFavorite: false)
            ImageItemManager.shared.saveImageItem(newImage)
            images = ImageItemManager.shared.loadImageItem()
            collectionView.reloadData()
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView {
            return images.count + 1
        }
        return firstCellArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionView {
            if indexPath.item == 0 {
                guard let firstCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FirstCollectionViewCell", for: indexPath) as? FirstCollectionViewCell else {
                    return UICollectionViewCell()
                }
                firstCell.configure(with: firstCellArray[indexPath.item])
                firstCell.delegate = self
                return firstCell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell else {
                    return UICollectionViewCell()
                }
                let image = images[indexPath.item - 1]
                cell.configure(with: image)
                cell.delegate = self
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let side: CGFloat = (view.frame.width - spacing) / 2
        return CGSize(width: side, height: side)
    }
}


