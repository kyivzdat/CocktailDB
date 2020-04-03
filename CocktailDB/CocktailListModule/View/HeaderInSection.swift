//
//  HeaderInSection.swift
//  CocktailDB
//
//  Created by Vladyslav Palamarchuk on 03.04.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import UIKit
import Foundation

class HeaderInSection {
    
    private let label = UILabel()
    private let headerView = UIView()
    
    private func setupHeaderView() {
        headerView.layer.borderWidth = 1
        headerView.layer.borderColor = #colorLiteral(red: 0.8864367604, green: 0.88595438, blue: 0.9034027457, alpha: 1)
        headerView.backgroundColor = #colorLiteral(red: 0.9374715686, green: 0.9368460178, blue: 0.9586812854, alpha: 1)
        headerView.addSubview(label)
    }
    
    private func setupLabel(with text: String?) {
        label.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .gray
        label.text = text
    }
    
    func getStyledHeader(with text: String?) -> UIView {
        setupHeaderView()
        setupLabel(with: text)
        return headerView
    }
}
