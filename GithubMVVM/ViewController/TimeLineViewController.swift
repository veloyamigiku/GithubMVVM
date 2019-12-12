//
//  TimeLineViewController.swift
//  GithubMVVM
//
//  Created by velo.yamigiku on 2019/12/12.
//  Copyright © 2019 velo.yamigiku. All rights reserved.
//

import UIKit
import SafariServices

class TimeLineViewController: UIViewController {
    
    private var viewModel: UserListViewModel!
    private var refreshControl: UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "TimeLineCell", bundle: nil), forCellReuseIdentifier: "TimeLineCell")
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(
            self,
            action: #selector(refreshControlValueDidChange(sender:)),
            for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        viewModel = UserListViewModel()
        viewModel.stateDidUpdate = { state in
            switch state {
            case .loading:
                // tableViewを操作不能にする。
                self.tableView.isUserInteractionEnabled = false
                break
            case .finish:
                // tableViewを操作可能にする。
                self.tableView.isUserInteractionEnabled = true
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                break
            case .error(let error):
                // tableViewを操作可能にする。
                self.tableView.isUserInteractionEnabled = true
                self.refreshControl.endRefreshing()
                
                let alertController = UIAlertController(
                    title: error.localizedDescription,
                    message: nil,
                    preferredStyle: .alert)
                let alertAction = UIAlertAction(
                    title: "OK",
                    style: .cancel,
                    handler: nil)
                alertController.addAction(alertAction)
                self.present(
                    alertController,
                    animated: true,
                    completion: nil)
                break
            }
        }
        viewModel.getUsers()
    }
    
    @objc func refreshControlValueDidChange(sender: UIRefreshControl) {
        viewModel.getUsers()
    }

}

extension TimeLineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let timeLineCell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell") as? TimeLineCell {
            
            let cellViewModel = viewModel.cellViewModels[indexPath.row]
            timeLineCell.setNickName(nickName: cellViewModel.nickName)
            cellViewModel.downloadImage(progress: { (progress) in
                switch progress {
                case .loading(let image):
                    timeLineCell.setIcon(icon: image)
                    break
                case .finish(let image):
                    timeLineCell.setIcon(icon: image)
                    break
                case .error:
                    break
                }
            })
            return timeLineCell
        }
        fatalError()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        let webURL = cellViewModel.webURL
        let webViewController = SFSafariViewController(url: webURL)
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
}
