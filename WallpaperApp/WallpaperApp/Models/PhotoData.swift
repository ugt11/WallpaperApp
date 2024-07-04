//
//  PhotoData.swift
//  WallpaperApp
//
//  Created by spark-04 on 2024/06/25.
//
import Foundation

struct PhotoData: Codable {
    let id: String
    let urls: PhotoURLs
    let user: UserData
    let updatedAt: String?
    let alternativeSlugs: PhotoTitle

    private enum CodingKeys: String, CodingKey {
        case id
        case urls
        case user
        case updatedAt = "updated_at"
        case alternativeSlugs = "alternative_slugs"
    }
}

struct SearchResponse: Codable {
    let results: [PhotoData]
}

struct PhotoTitle: Codable {
    let ja: String?
    
    private enum CodingKeys: String, CodingKey {
        case ja
    }
}


struct PhotoURLs: Codable {
    let regular: URL?
    
    private enum CodingKeys: String, CodingKey {
        case regular
    }
}


struct UserData: Codable {
    let username: String?
    let name: String?
    
    private enum CodingKeys: String, CodingKey {
        case username
        case name
    }
}

