//
//  HomeViewController.swift
//  WallpaperApp
//
//  Created by spark-04 on 2024/06/25.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!

    var photoURLs: [URL] = []
    let photoModel = PhotoModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // DataSourceとDelegateを設定する
        collectionView.dataSource = self
        collectionView.delegate = self

        // カスタムのCollectionViewCellクラスを登録する
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "Cell")

        collectionView.register(UINib(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
        // PhotoModelを使用してAPIから写真のデータを取得する
        photoModel.fetchPhotos { [weak self] result in
            switch result {
            case .success(let fetchedPhotoData):
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                //print("取得した写真の数: \(fetchedPhotoData.count)")
            case .failure(let error):
                // エラーの場合の処理
                print("写真の取得に失敗しました:", error)
            }
        }
    }

    // セクション内のアイテム数を返す
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModel.photos?.count ?? 0
    }

    // セルを設定する
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCell
        
        // photoModelからPhotoDataを取得する
        if let photoData = photoModel.photos?[indexPath.item],
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
                let selectedPhotoData = photoModel.photos?[indexPath.item]
                let destinationViewController = segue.destination as! DetailViewController
                destinationViewController.photoData = selectedPhotoData
            }
        }
    }
}
