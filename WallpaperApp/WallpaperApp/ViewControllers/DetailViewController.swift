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
        
        setupView()
        setupGestures()
    }
    
    private func setupView() {
        if let alternativeSlugs = photoData?.alternativeSlugs.ja {
            let components = alternativeSlugs.components(separatedBy: "-")
            self.title = components.first ?? "No Description"
        } else {
            self.title = "No Description"
        }
        
        guard let photoData = photoData else { return }
        
        // 画像とその他の詳細を表示する
        if let photoURLString = photoData.urls.regular?.absoluteString,
           let photoURL = URL(string: photoURLString) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: photoURL) {
                    DispatchQueue.main.async {
                        self.imageDetail.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        // 写真家のユーザ名を表示し、リンクを作成する
        if let username = photoData.user.username {
            let linkString = "https://unsplash.com/ja/@\(username)"
            let attributedString = NSAttributedString(string: photoData.user.name ?? "Unknown Photographer", attributes: [.link: URL(string: linkString)])
            photographerName.attributedText = attributedString
            photographerName.isUserInteractionEnabled = true
        } else {
            photographerName.text = "Unknown Photographer"
        }
        
        // ディストリビュータをリンクに設定する
        if let distributorURLString = photoData.urls.full?.absoluteString,
           let url = URL(string: distributorURLString) {
            let attributedString = NSAttributedString(string: "Unsplash", attributes: [.link: url])
            distributor.attributedText = attributedString
            distributor.isUserInteractionEnabled = true
        }
        
        // 更新日が利用可能な場合は日付形式にフォーマットして表示する
        if let updateDateString = photoData.updatedAt {
            let formattedDate = formatDate(updateDateString)
            updateDate.text = formattedDate
        }
    }
    
    private func setupGestures() {
        // 写真家の名前にタップジェスチャーを追加
        let photographerTapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePhotographerNameTap))
        photographerName.addGestureRecognizer(photographerTapGesture)
        
        // ディストリビュータにタップジェスチャーを追加
        let distributorTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDistributorTap))
        distributor.addGestureRecognizer(distributorTapGesture)
        
        // 画像をタップしたときにsegueを実行するための設定
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        imageDetail.addGestureRecognizer(imageTapGesture)
        imageDetail.isUserInteractionEnabled = true
    }
    
    private func formatDate(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy年M月d日"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    @objc private func handlePhotographerNameTap() {
        if let username = photoData?.user.username {
            let webKitVC = WebKitViewController()
            webKitVC.linkString = "https://unsplash.com/ja/@\(username)"
            present(webKitVC, animated: true, completion: nil)
        } else {
            photographerName.text = "Unknown account"
        }
    }
    
    @objc private func handleDistributorTap() {
        if let urlString = photoData?.urls.full?.absoluteString,
           let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func handleImageTap() {
        performSegue(withIdentifier: "toExpansion", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExpansion",
           let destinationVC = segue.destination as? DetailExpansionViewController {
            destinationVC.image = imageDetail.image
        }
    }
}
