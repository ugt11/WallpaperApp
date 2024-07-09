//
//  DetailExpansionViewController.swift
//  WallpaperApp
//
//  Created by spark-04 on 2024/07/03.
//

import UIKit

class DetailExpansionViewController: UIViewController, UIScrollViewDelegate,  UIGestureRecognizerDelegate {
    
    var image: UIImage?
    var initialScale: CGFloat = 0.0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.delaysContentTouches = false
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        pinchGesture.delegate = self
        scrollView.addGestureRecognizer(pinchGesture)
        
        imageView.contentMode = .scaleAspectFit
        scrollView.contentSize = imageView.frame.size
        
    }
    
    @objc func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1.0 {
            // タップした場所を中心に拡大
            let zoomRect = zoomForScale(scale: scrollView.maximumZoomScale, center: gestureRecognizer.location(in: imageView))
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            // 元のサイズに戻す
            scrollView.setZoomScale(1.0, animated: true)
        }
    }
    
    @objc func handlePinch(_ gestureRecognizer: UIPinchGestureRecognizer) {
        if gestureRecognizer.state == .began {
            initialScale = scrollView.zoomScale
        } else if gestureRecognizer.state == .changed {
            let currentScale = initialScale * gestureRecognizer.scale
            scrollView.zoomScale = currentScale
            updateContentSize()
        } else if gestureRecognizer.state == .ended {
            gestureRecognizer.scale = 1.0
        }
    }

    func updateContentSize() {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = max(scrollView.zoomScale, minScale)
        
        let contentSize = CGSize(width: imageViewSize.width * scrollView.zoomScale,
                                  height: imageViewSize.height * scrollView.zoomScale)
        scrollView.contentSize = contentSize
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func zoomForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect: CGRect = CGRect()
        
        // ズーム後の高さと幅を計算
        zoomRect.size.height = self.scrollView.frame.size.height / scale
        zoomRect.size.width = self.scrollView.frame.size.width / scale
        
        // ズームの中心点をそのまま使用する
        zoomRect.origin.x = center.x - zoomRect.size.width / 2.0
        zoomRect.origin.y = center.y - zoomRect.size.height / 2.0
        
        return zoomRect
    }
}
