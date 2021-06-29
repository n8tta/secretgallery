//
//  ImageItemManager.swift
//  SecretGallery
//
//  Created by Natallia Valadzko on 17.02.21.
//

import Foundation
import UIKit

//MARK: - Enum
enum ImageItemKeys: String {
    case itemKey
}

//MARK: - Class ImageItemManager
class ImageItemManager {
    
    //MARK: - Constants
    static let shared = ImageItemManager() 
    
    //MARK: - Flow functions
    func saveImageItem(_ imageItems: Image) {
        var array = self.loadImageItem()
        array.append(imageItems)
        UserDefaults.standard.set(encodable: array, forKey: ImageItemKeys.itemKey.rawValue)
    }
    
    func loadImageItem() -> [Image] {
        guard let imageItems = UserDefaults.standard.value([Image].self, forKey: ImageItemKeys.itemKey.rawValue) else {
            return []
        }
        return imageItems
    }
    
    func saveCaption(image: Image, caption: String) {
        let array = self.loadImageItem()
        var newArray = [Image]()
        for element in array {
            if element.image == image.image {
                element.caption = caption
            }
            newArray.append(element)
        }
        UserDefaults.standard.set(encodable: newArray, forKey: ImageItemKeys.itemKey.rawValue)
    }
    
    func saveFavorite(image: Image, isFavorite: Bool) {
        let array = self.loadImageItem()
        var newArray = [Image]()
        for element in array {
            if element.image == image.image {
                element.isFavorite = isFavorite
            }
            newArray.append(element)
        }
        UserDefaults.standard.set(encodable: newArray, forKey: ImageItemKeys.itemKey.rawValue)
    }
    
    
    func deleteImage(image: Image, index: Int) {
        var array = self.loadImageItem()
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        if let fileName = image.image {
            let imagePath = "\(documentsDirectory.absoluteURL.absoluteString)\(fileName)".replacingOccurrences(of: "file://", with: "")
            if FileManager.default.fileExists(atPath: imagePath) {
                do {
                    try FileManager.default.removeItem(atPath: imagePath)
                    array.remove(at: index)
                    print("Image was removed")
                    UserDefaults.standard.set(encodable: array, forKey: ImageItemKeys.itemKey.rawValue)
                } catch {
                    print(error)
                }
            }
        }
    }
    
}
