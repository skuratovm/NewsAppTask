//
//  NewsTableViewCellModel.swift
//  NewsTask
//
//  Created by Mikhail Skuratov on 4.02.22.
//
import Foundation

class NewsTableViewCellViewModel:Codable {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data?
    
    init(
        title: String,
        subtitle: String,
        imageURL: URL?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}
