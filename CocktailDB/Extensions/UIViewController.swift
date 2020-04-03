//
//  UIViewController.swift
//  CocktailDB
//
//  Created by Vladyslav Palamarchuk on 01.04.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {
    
    /// Get color for different interface style (dark/light)
    func getRightTextColor() -> UIColor {
        var color = UIColor.black
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                color = .white
            }
        }
        return color
    }
}
