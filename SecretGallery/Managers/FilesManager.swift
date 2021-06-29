//
//  FilesManager.swift
//  SecretGallery
//
//  Created by Natallia Valadzko on 17.02.21.
//

import Foundation
import UIKit

class FilesManager {
    
    //MARK: - Constants
    static let shared = FilesManager()
    
    //MARK: - Flow functions
    func saveImage(image: UIImage) -> String? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
        let fileName = UUID().uuidString
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return nil}
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let error {
                print("couldn't remove file at path", error)
            }
        }
        do {
            try data.write(to: fileURL)
            return fileName
        } catch let error {
            print("Error saving file with error", error)
            return nil
        }
    }
    
    func loadImage(fileName: String) -> UIImage? {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imageUrl = documentsDirectory.appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
}
