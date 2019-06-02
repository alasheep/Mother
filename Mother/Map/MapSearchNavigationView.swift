//
//  MapSearchNavigationView.swift
//  Mother
//
//  Created by Apple on 23/05/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import IBAnimatable

class MapSearchNavigationView: UIView, NibLoadable {
    
    @IBOutlet weak var searchButton: AnimatableButton!
    
    @IBOutlet weak var avatarButton: UIButton!
    
    /// 搜索按钮点击
    var didSelectSearchButton: (()->())?
    /// 头像按钮点击
    var didSelectAvatarButton: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        searchButton.theme_backgroundColor = "colors.cellBackgroundColor"
//        searchButton.theme_setTitleColor("colors.grayColor150", forState: .normal)
        searchButton.setImage(UIImage(named: "search_small_16x16_"), for: [.normal, .highlighted])
//        cameraButton.theme_setImage("images.home_camera", forState: .normal)
//        cameraButton.theme_setImage("images.home_camera", forState: .highlighted)
//        avatarButton.theme_setImage("images.home_no_login_head", forState: .normal)
//        avatarButton.theme_setImage("images.home_no_login_head", forState: .highlighted)
        // 首页顶部导航栏搜索推荐标题内容
//        NetworkTool.loadHomeSearchSuggestInfo { (suggest) in
//            self.searchButton.setTitle(suggest, for: .normal)
//        }
    }
    
    /// 固有的大小
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    /// 重写 frame
    override var frame: CGRect {
        didSet {
            super.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 44)
        }
    }
    
    /// 头像按钮点击
    @IBAction func avatarButtonClicked(_ sender: UIButton) {
        didSelectAvatarButton?()
    }
    
    /// 搜索按钮点击
    @IBAction func searchButtonClicked(_ sender: AnimatableButton) {
        didSelectSearchButton?()
    }
    
}

