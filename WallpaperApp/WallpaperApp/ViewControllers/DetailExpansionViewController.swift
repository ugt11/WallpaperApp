//
//  DetailExpansionViewController.swift
//  WallpaperApp
//
//  Created by spark-04 on 2024/07/03.
//

import UIKit

class DetailExpansionViewController: UIViewController {
    
    var image: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
}
