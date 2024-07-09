//
//  TagViewController.swift
//  WallpaperApp
//
//  Created by spark-04 on 2024/07/01.
//

import UIKit

class TagViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    
    var photoURLs: [URL] = []
    var tagModel = TagModel()
    var selectedButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DataSourceとDelegateを設定する
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // カスタムのCollectionViewCellクラスを登録する
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "Cell")
        
        // 初期の色でsearchPhotosメソッドを呼び出す
        searchPhotos(with: "red")
        
        selectedButton = redButton
        selectedButton?.tintColor = .white
        selectedButton?.backgroundColor = .black
        selectedButton?.layer.cornerRadius = 7
        
    }

    func searchPhotos(with color: String) {
        tagModel.searchPhotos(with: color) { result in
            switch result {
            case .success(let fetchedPhotoData):
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                // エラーの場合の処理
                print("写真の取得に失敗しました:", error)
            }
        }
    }
    @IBAction func searchRedPhotos(_ sender: UIButton) {
        updateSelectedButton(sender)
        searchPhotos(with: "red")
    }

    @IBAction func searchBluePhotos(_ sender: UIButton) {
        updateSelectedButton(sender)
        searchPhotos(with: "blue")
    }

    @IBAction func searchGreenPhotos(_ sender: UIButton) {
        updateSelectedButton(sender)
        searchPhotos(with: "green")
    }

    @IBAction func searchYellowPhotos(_ sender: UIButton) {
        updateSelectedButton(sender)
        searchPhotos(with: "yellow")
    }

    @IBAction func searchWhitePhotos(_ sender: UIButton) {
        updateSelectedButton(sender)
        searchPhotos(with: "white")
    }

    @IBAction func searchBlackPhotos(_ sender: UIButton) {
        updateSelectedButton(sender)
        searchPhotos(with: "black")
    }
    
    func updateSelectedButton(_ button: UIButton) {
        // 前回選択されていたボタンの状態を戻す
        if let previousButton = selectedButton {
            previousButton.isSelected = false
            previousButton.backgroundColor = previousButton.titleColor(for: .normal)
            previousButton.tintColor = .black
            previousButton.layer.cornerRadius = 0
        }
        
        // 新しく選択されたボタンの状態を更新する
        button.isSelected = true
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 7
        
        selectedButton = button
    }

    
    // セクション内のアイテム数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagModel.photos?.count ?? 0
    }
    
    // セルを設定する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCell
        
        // photoModelからPhotoDataを取得する
        if let photoData = tagModel.photos?[indexPath.item],
           let photoURLString = photoData.urls.regular?.absoluteString {
            let photographerName = photoData.user.name // 撮影者の名前を取得する
            cell.configure(with: photoURLString, photographerName: photographerName)
        }
        
        return cell
    }
    // セルのサイズを設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            // 一枚目の画像のセルのサイズを設定する
            let collectionViewWidth = collectionView.bounds.width - 10 // 左右に10の余白を追加する
            return CGSize(width: collectionViewWidth, height: collectionViewWidth)
        } else {
            // 二枚目以降の画像のセルのサイズを設定する（2列にする）
            let padding: CGFloat = 5
            let collectionViewWidth = collectionView.bounds.width - padding * 3
            let cellWidth = (collectionViewWidth - padding) / 2 // セル間にもpaddingを考慮する
            return CGSize(width: cellWidth, height: cellWidth)
        }
    }
    // セル間の最小間隔を設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5 // セル間の間隔を調整する
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
        header.configure(title: "新着写真")
        return header
    }
    
    // セクションの余白を設定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding: CGFloat = 5
        let bottomPadding: CGFloat = 100 // 一番下に空けたいスペースのサイズを設定する
        return UIEdgeInsets(top: padding, left: padding, bottom: bottomPadding, right: padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if let indexPath = sender as? IndexPath {
                let selectedPhotoData = tagModel.photos?[indexPath.item]
                let destinationViewController = segue.destination as! DetailViewController
                destinationViewController.photoData = selectedPhotoData
            }
        }
    }
}
