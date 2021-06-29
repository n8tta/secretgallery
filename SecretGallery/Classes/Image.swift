//
//  Image.swift
//  SecretGallery
//
//  Created by Natallia Valadzko on 1.02.21.
//


import UIKit

//MARK: - Class Image
class Image: Codable {
    var image: String?
    var caption: String?
    var isFavorite: Bool?

    //MARK: - Initializer
    init(image: String?, caption: String?, isFavorite: Bool?) {
        self.image = image
        self.caption = caption
        self.isFavorite = isFavorite
    }

    //MARK: - Enum
    private enum CodingKeys: String, CodingKey {
        case imageKey
        case captionKey
        case isFavoriteKey
    }

    //MARK: - Initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        image = try container.decodeIfPresent(String.self, forKey: .imageKey)
        caption = try container.decodeIfPresent(String.self, forKey: .captionKey)
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavoriteKey)
    }

    //MARK: - Flow function
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.image, forKey: .imageKey)
        try container.encode(self.caption, forKey: .captionKey)
        try container.encode(self.isFavorite, forKey: .isFavoriteKey)
    }
}
