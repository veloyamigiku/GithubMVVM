//
//  UserListViewModel.swift
//  GithubMVVM
//
//  Created by velo.yamigiku on 2019/12/09.
//  Copyright © 2019 velo.yamigiku. All rights reserved.
//

import UIKit

// 通信状態を定義する。
enum ViewModelState {
    case loading
    case finish
    case error(Error)
}

final class UserListViewModel {
    
    // Closureを保持するプロパティを宣言する。
    var stateDidUpdate: ((ViewModelState) -> Void)?
    
    // Userの配列を宣言する。
    private var users = [User]()
    
    var cellViewModels = [UserCellViewModel]()
    
    // APIのインスタンスのプロパティを宣言する。
    let api = API()
    
    func getUsers() {
        
        // 通信状態を通知する。
        stateDidUpdate?(.loading)
        users.removeAll()
        
        api.getUsers(
            success: { (users) in
                self.users.append(contentsOf: users)
                for user in users {
                    let cellViewModel = UserCellViewModel(user: user)
                    self.cellViewModels.append(cellViewModel)
                    
                    // 通信状態を通知する。
                    self.stateDidUpdate?(.finish)
                }
            },
            failure: { (error) in
                // 通信状態を通知する。
                self.stateDidUpdate?(.error(error))
            })
    }
    
    func usersCount() -> Int {
        return users.count
    }
    
}
