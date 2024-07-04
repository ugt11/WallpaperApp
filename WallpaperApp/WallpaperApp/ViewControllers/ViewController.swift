//
//  ViewController.swift
//  WallpaperApp
//
//  Created by spark-04 on 2024/06/25.
//

import UIKit

class ViewController: UIViewController, FooterTabViewDelegate {
    
    @IBOutlet weak var footerTabView: FooterTabView! {
        didSet {
            footerTabView.delegate = self
        }
    }
    
    var selectedTab: FooterTab = .home
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchViewController(selectedTab: .home)
    }
    
    private lazy var homeViewController: HomeViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        add(childViewController: viewController)
        return viewController
    }()
    
    private lazy var tagViewController: TagViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "TagViewController") as! TagViewController
        add(childViewController: viewController)
        return viewController
    }()
    
    private lazy var appViewController: AppViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "AppViewController") as! AppViewController
        add(childViewController: viewController)
        return viewController
    }()
    
    private func switchViewController(selectedTab: FooterTab) {
        // 選択されたタブに応じてビューコントローラーを切り替える
        switch selectedTab {
        case .home:
            remove(childViewController: tagViewController)
            remove(childViewController: appViewController)
            add(childViewController: homeViewController)
        case .tag:
            remove(childViewController: homeViewController)
            remove(childViewController: appViewController)
            add(childViewController: tagViewController)
        case .app:
            remove(childViewController: homeViewController)
            remove(childViewController: tagViewController)
            add(childViewController: appViewController)
        }
        self.selectedTab = selectedTab
        view.bringSubviewToFront(footerTabView)
    }
    
    private func add(childViewController: UIViewController) {
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParent: self)
    }
    
    private func remove(childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
    
    func footerTabView(_ footerTabView: FooterTabView, didselectTab selectedTab: FooterTab) {
        switchViewController(selectedTab: selectedTab)
    }
}
