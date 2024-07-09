//
//  WebKitViewController.swift
//  WallpaperApp
//
//  Created by spark-04 on 2024/07/05.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var linkString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // WKWebViewのインスタンスを作成
        webView = WKWebView(frame: self.view.bounds)
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        if let url = URL(string: linkString) {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            showError(message: "Invalid URL")
        }
    }
    
    func showError(message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
}
