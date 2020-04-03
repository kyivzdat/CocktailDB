//
//  UITableView.swift
//  CocktailDB
//
//  Created by Vladyslav Palamarchuk on 02.04.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import UIKit
import Foundation

typealias ControllerWithTable = UITableViewDelegate & UITableViewDataSource & UIViewController

extension UITableView {
    func setupTableView(for vc: ControllerWithTable, cellClass: UITableViewCell.Type, forCellReuseIdentifier identifier: String) {
        vc.view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(cellClass, forCellReuseIdentifier: identifier)
        
        self.delegate = vc
        self.dataSource = vc
        self.tableFooterView = UIView(frame: .zero)
    }
}
