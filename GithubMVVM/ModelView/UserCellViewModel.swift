//
//  UserCellViewModel.swift
//  GithubMVVM
//
//  Created by velo.yamigiku on 2019/12/09.
//  Copyright © 2019 velo.yamigiku. All rights reserved.
//

import UIKit

// 画像ダウンロード状態を定義する。
enum ImageDownloadProgress {
    case loading(UIImage)
    case finish(UIImage)
    case error
}

class UserCellViewModel: NSObject {
    
    // ユーザのプロパティを宣言する。
    // MVCでは、Viewが持っていた。
    private var user: User
    
    // 画像ダウンローダのプロパティを宣言する。
    private let imageDownloader = ImageDownloader()
    
    // 画像ダウンロード中かのプロパティを宣言する。
    private var isLoading = false
    
    // ViewModel経由で、Modelのデータを参照するインタフェースを用意する。
    var nickName: String {
        return user.name
    }
    
    // ViewModel経由で、Modelのデータを参照するインタフェースを用意する。
    var webURL: URL {
        return URL(string: user.webURL)!
    }
    
    init(user: User) {
        self.user = user
    }
    
    // ViewModel経由で、Modelのデータを参照するインタフェースを用意する。
    func downloadImage(progress: @escaping (ImageDownloadProgress) -> Void) {
        
        if isLoading == true {
            return
        }
        isLoading = true
        
        let loadingImage = UIImage(color: .gray, size: CGSize(width: 45, height: 45))!
        
        progress(.loading(loadingImage))
        
        imageDownloader.downloadImage(
            imageURL: user.iconUrl,
            success: { (image) in
                progress(.finish(image))
                self.isLoading = false
            }, failure: { (error) in
                progress(.error)
                self.isLoading = false
            })
    }
}

extension UIImage {
    
    convenience init?(color: UIColor, size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(
            rect.size,
            false,
            0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
    
}
