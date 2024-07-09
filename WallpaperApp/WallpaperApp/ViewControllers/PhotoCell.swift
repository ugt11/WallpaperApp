//
//  PhotoCell.swift
//  WallpaperApp
//
//  Created by spark-04 on 2024/06/25.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    var imageView: UIImageView!
    var nameLabel: UILabel!
    
    private var dataTask: URLSessionDataTask?
    private var imageURL: URL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // 上側の角を丸くする
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        nameLabel = UILabel()
            nameLabel.textColor = .black
            nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(nameLabel)
            NSLayoutConstraint.activate([
                nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                nameLabel.heightAnchor.constraint(equalToConstant: 25),
                nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15) // 配置を指定
            ])

            let whiteView = UIView()
            whiteView.backgroundColor = .white
            whiteView.translatesAutoresizingMaskIntoConstraints = false
            contentView.insertSubview(whiteView, belowSubview: nameLabel)
            NSLayoutConstraint.activate([
                whiteView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -15),
                whiteView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                whiteView.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -5),
                whiteView.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5)
            ])

            whiteView.layer.cornerRadius = 18
            whiteView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil // 画像をクリアする
        imageURL = nil // URL をクリアする
        dataTask?.cancel() // 前のリクエストをキャンセルする
    }
    
    func configure(with photoURLString: String, photographerName: String?) {
        guard let imageURL = URL(string: photoURLString) else {
            // URLが取得できなかった場合の処理
            return
        }
        
        self.imageURL = imageURL
        
        dataTask = URLSession.shared.dataTask(with: self.imageURL!) { [weak self] (data, response, error) in
            guard let self = self else { return }
            guard let data = data, error == nil else {
                print("画像データの読み込みに失敗しました:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.imageView.contentMode = .scaleAspectFill
                self.imageView.image = self.cropToSquare(image: image)
            }
        }
        
        if let name = photographerName {
            nameLabel.text = name
        } else {
            nameLabel.text = "Unknown" // 撮影者の名前が不明の場合は"Unknown"を表示する
        }
        
        dataTask?.resume()
    }
    
    private func cropToSquare(image: UIImage?) -> UIImage? {
        guard let image = image else { return nil }
        
        let shorterSide = min(image.size.width, image.size.height)
        let size = CGSize(width: shorterSide, height: shorterSide)
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let croppedImage = renderer.image { context in
            let origin = CGPoint(x: (size.width - image.size.width) / 2, y: (size.height - image.size.height) / 2)
            image.draw(at: origin)
        }
        
        return croppedImage
    }
}
