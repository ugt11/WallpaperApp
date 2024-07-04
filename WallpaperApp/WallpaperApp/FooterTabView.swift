//
//  FooterTabView.swift
//  WallpaperApp
//
//  Created by spark-04 on 2024/07/01.
//

import UIKit

enum FooterTab {
    case home
    case tag
    case app
}

protocol FooterTabViewDelegate: AnyObject {
    func footerTabView(_ footerTabView: FooterTabView, didselectTab: FooterTab)
}

class FooterTabView: UIView {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var delegate: FooterTabViewDelegate?
    
    @IBAction func didTapHome(_ sender: Any) {
        delegate?.footerTabView(self, didselectTab: .home)
    }
    
    @IBAction func didTapTag(_ sender: Any) {
        delegate?.footerTabView(self, didselectTab: .tag)
    }
    @IBAction func didTapApp(_ sender: Any) {
        delegate?.footerTabView(self, didselectTab: .app)
    }
    //カスタムビューの初期化メソッド
    override init(frame: CGRect) {
        super.init(frame: frame)
        load()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        load()
        setup()
    }
    
    //影を背景につけて丸みをつけるコード
    func setup() {
        // contentViewの角を丸くする設定
        contentView.layer.cornerRadius = 32 // より丸くする
        contentView.layer.masksToBounds = true
        
        // shadowViewの角を丸くする設定
        shadowView.layer.cornerRadius = 32 // contentViewと同じ角丸にする
        shadowView.layer.masksToBounds = false // shadowViewではmasksToBoundsをfalseにする
        
        // 影の設定
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 1 // 影を濃くする
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 2)
        shadowView.layer.shadowRadius = 5 // シャープにする
    }
    //カスタムビューを持っていくためのコード
    func load() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
}
