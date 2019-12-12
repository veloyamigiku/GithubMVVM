//
//  TimeLineCell.swift
//  GithubMVVM
//
//  Created by velo.yamigiku on 2019/12/12.
//  Copyright © 2019 velo.yamigiku. All rights reserved.
//

import UIKit

class TimeLineCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        iconView.layer.cornerRadius = iconView.frame.size.width / 2
        
    }
    
    func setNickName(nickName: String) {
        nickNameLabel.text = nickName
    }
    
    func setIcon(icon: UIImage) {
        iconView.image = icon
    }
    
}
