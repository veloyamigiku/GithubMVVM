//
//  ImageDownloader.swift
//  GithubMVVM
//
//  Created by velo.yamigiku on 2019/12/05.
//  Copyright © 2019 velo.yamigiku. All rights reserved.
//

import Foundation
import UIKit

final class ImageDownloader {
    
    // UIImageをキャッシュする変数。
    var cacheImage: UIImage?
    
    func downloadImage(
        imageURL: String,
        success: @escaping (UIImage) -> Void,
        failure: @escaping (Error) -> Void) {
        
        
        if let cacheImage = cacheImage {
            success(cacheImage)
        }
        
        var request = URLRequest(url: URL(string: imageURL)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Errorがある場合は、ErrorをClosureで返却する。
            if let error = error {
                DispatchQueue.main.async {
                    failure(error)
                }
            }
            
            // dataがない場合は、APIError.unknownをClosureで返却する。
            guard let data = data else {
                DispatchQueue.main.async {
                    failure(APIError.unknown)
                }
                return
            }
            
            // 受け取ったデータからUIImageを生成できない場合は、APIError.unknownをClosureで返却する。
            guard let imageFromData = UIImage(data: data) else {
                DispatchQueue.main.async {
                    failure(APIError.unknown)
                }
                return
            }
            
            DispatchQueue.main.async {
                success(imageFromData)
            }
            
            // 画像をキャッシュする。
            self.cacheImage = imageFromData
        }
        task.resume()
        
    }
}
