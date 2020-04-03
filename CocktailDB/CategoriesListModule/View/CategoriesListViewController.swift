//
//  CategoriesListViewController.swift
//  CocktailDB
//
//  Created by Vladyslav Palamarchuk on 31.03.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import UIKit

final class CategoriesListViewController: UIViewController {
    
    private var tableView = UITableView()
    private var applyFiltersButton: UIButton!
    var presenter: CategoriesListViewPresenter!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupApplyButton()
        setupTableView()
        view.backgroundColor = tableView.backgroundColor
    }
    
    private func setupApplyButton() {
        let buttonCreator = ApplyButton()
        applyFiltersButton = buttonCreator.getStyledButton(on: view)
        applyFiltersButton.addTarget(self, action: #selector(tapApplyFiltersButton), for: .touchUpInside)
    }
    
    private func setupTableView() {
        tableView.setupTableView(for: self, cellClass: UITableViewCell.self, forCellReuseIdentifier: "categoriesCell")
        tableView.snp.makeConstraints { (make) in
            make.right.top.left.equalToSuperview()
            make.bottom.equalTo(applyFiltersButton.snp.top)
        }
    }
    
    // MARK: - Navigation
    @objc private func tapApplyFiltersButton(_ sender: UIButton) {
        guard let parentVC = navigationController?.children.first as? CocktailListViewController else { return }
        
        parentVC.presenter.printCategories = presenter.getSelectedCategories()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Presenter

extension CategoriesListViewController: CategoriesListView {
    
    func changedColorButton(isActive: Bool) {
        let textColor = isActive ? getRightTextColor() : .gray
        applyFiltersButton.setTitleColor(textColor, for: .normal)
        applyFiltersButton?.isEnabled = isActive
    }
}

// MARK: - UITableViewDataSource

extension CategoriesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.oldCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoriesCell", for: indexPath)
        
        let category = presenter.newCategories[indexPath.row]
        cell.textLabel?.text = "  " + category.strCategory
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.textLabel?.textColor = category.isSelected ? getRightTextColor() : .systemGray
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoriesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeTextColor(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func changeTextColor(_ indexPath: IndexPath) {
        guard
            let cell = tableView.cellForRow(at: indexPath),
            let isSelected = presenter.newCategories[indexPath.row].isSelected else { return }
        
        presenter.newCategories[indexPath.row].isSelected = !isSelected
        cell.textLabel?.textColor = !isSelected ? getRightTextColor() : .systemGray
    }
}
