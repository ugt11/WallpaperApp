//
//  AppViewController.swift
//  WallpaperApp
//
//  Created by spark-04 on 2024/07/04.
//

import UIKit
import WebKit

class AppViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func webButton(_ sender: Any) {
        let webKitVC = WebKitViewController()
                webKitVC.linkString = "https://unsplash.com"
                self.present(webKitVC, animated: true, completion: nil)
    }
    
}
