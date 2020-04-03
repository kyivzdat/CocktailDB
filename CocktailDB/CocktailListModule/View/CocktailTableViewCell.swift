//
//  CocktailTableViewCell.swift
//  CocktailDB
//
//  Created by Vladyslav Palamarchuk on 31.03.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import UIKit
import SnapKit

final class CocktailTableViewCell: UITableViewCell {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    var photoImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        placeObjectOnView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard selected else { return }
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.3) {
                            self.transform = .identity
                        }
        })
    }
    
    func placeObjectOnView() {
        addSubview(titleLabel)
        addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(16)
            make.leftMargin.equalToSuperview().inset(24)
            make.width.equalTo(photoImageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(photoImageView.snp.right).inset(-16)
        }
    }
}
