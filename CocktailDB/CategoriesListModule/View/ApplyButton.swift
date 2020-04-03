//
//  ApplyButton.swift
//  CocktailDB
//
//  Created by Vladyslav Palamarchuk on 02.04.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import UIKit
import SnapKit
import Foundation

final class ApplyButton {
    
    private var button: UIButton
    
    init(button: UIButton = UIButton()) {
        self.button = button
    }
    
    func getStyle() {
        button.isEnabled = false
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.setTitle("Apply Filters", for: .normal)
        
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    }
    
    func placeButton(on view: UIView) {
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.bottom.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview().multipliedBy(0.85)
        }
    }
    
    func getStyledButton(on view: UIView) -> UIButton {
        getStyle()
        placeButton(on: view)
        return button
    }
}
