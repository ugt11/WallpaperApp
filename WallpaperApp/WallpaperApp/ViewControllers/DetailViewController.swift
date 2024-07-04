//
//  DetailViewController.swift
//  WallpaperApp
//
//  Created by spark-04 on 2024/07/02.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var photographerName: UILabel!
    @IBOutlet weak var distributor: UILabel!
    @IBOutlet weak var updateDate: UILabel!
    
    var photoData: PhotoData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let alternativeSlugs = photoData?.alternativeSlugs.ja {
            let components = alternativeSlugs.components(separatedBy: "-")
            self.title = components.first ?? "No Description"
        } else {
            self.title = "No Description"
        }
        
        if let photoData = photoData {
            
            // 画像とその他の詳細を表示する
            if let photoURLString = photoData.urls.regular?.absoluteString {
                if let photoURL = URL(string: photoURLString) {
                    DispatchQueue.global().async {
                        if let imageData = try? Data(contentsOf: photoURL) {
                            DispatchQueue.main.async {
                                let image = UIImage(data: imageData)
                                self.imageDetail.image = image
                            }
                        }
                    }
                }
            }
            
            // 写真家のユーザ名を表示し、リンクを作成する
            if let username = photoData.user.username {
                let linkString = "https://unsplash.com/ja/@\(username)"
                let attributedString = NSAttributedString(string: photoData.user.name!, attributes: [.link: URL(string: linkString)])
                photographerName.attributedText = attributedString
                photographerName.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePhotographerNameTap))
                photographerName.addGestureRecognizer(tapGesture)
            } else {
                // ユーザ名がnilの場合、デフォルトのユーザ名を表示する
                photographerName.text = "Unknown Photographer"
            }
            
            // ディストリビュータをリンクに設定する
            if let distributorURLString = photoData.urls.regular?.absoluteString {
                if let url = URL(string: distributorURLString) {
                    let attributedString = NSAttributedString(string: "Unsplash", attributes: [.link: url])
                    distributor.attributedText = attributedString
                    distributor.isUserInteractionEnabled = true
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDistributorTap))
                    distributor.addGestureRecognizer(tapGesture)
                }
            }
            
            // 更新日が利用可能な場合は日付形式にフォーマットして表示する
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            if let updateDateString = photoData.updatedAt {
                if let updateDate = dateFormatter.date(from: updateDateString) {
                    dateFormatter.dateFormat = "yyyy年M月d日"
                    let formattedDate = dateFormatter.string(from: updateDate)
                    self.updateDate.text = "\(formattedDate)"
                }
            }
        }
        
        // 画像をタップしたときにsegueを実行するための設定
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        imageDetail.addGestureRecognizer(tapGesture)
        imageDetail.isUserInteractionEnabled = true
    }
    
    @objc func handlePhotographerNameTap() {
        if let username = photoData?.user.username {
            let linkString = "https://unsplash.com/ja/@\(username)"
            if let url = URL(string: linkString) {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc func handleDistributorTap() {
        if let urlString = photoData?.urls.regular?.absoluteString,
           let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func handleImageTap() {
        performSegue(withIdentifier: "toExpansion", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExpansion" {
            if let destinationVC = segue.destination as? DetailExpansionViewController {
                destinationVC.image = imageDetail.image
            }
        }
    }
}

