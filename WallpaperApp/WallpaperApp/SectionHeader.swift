//
//  SectionHeader.swift
//  WallpaperApp
//
//  Created by spark-04 on 2024/07/03.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
