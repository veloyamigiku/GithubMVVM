//
//  User.swift
//  GithubMVVM
//
//  Created by velo.yamigiku on 2019/12/04.
//  Copyright © 2019 velo.yamigiku. All rights reserved.
//

final class User {
    
    let id: Int
    let name: String
    let iconUrl: String
    let webURL: String
    
    init(attributes: [String: Any]) {
        id = attributes["id"] as! Int
        name = attributes["login"] as! String
        iconUrl = attributes["avator_url"] as! String
        webURL = attributes["html_url"] as! String
    }
    
}
