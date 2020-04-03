//
//  CocktailListViewController.swift
//  CocktailDB
//
//  Created by Vladyslav Palamarchuk on 31.03.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import MBProgressHUD

final class CocktailListViewController: UIViewController {
    
    // MARK: Properties
    private var filterBarButton: UIBarButtonItem!
    private var progressHUD: MBProgressHUD!
    private var tableView = UITableView()
    var presenter: CocktailListViewPresenter!

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupProgressHud()
        setupNavigationBar()
        setupPresenter()
    }
    
    private func setupTableView() {
        tableView.setupTableView(for: self, cellClass: CocktailTableViewCell.self, forCellReuseIdentifier: "cocktailCell")
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupProgressHud() {
        progressHUD = MBProgressHUD(view: self.view)
        progressHUD.animationType = .fade
        progressHUD.label.text = "Loading"
        progressHUD.center = view.center
        self.view.addSubview(progressHUD)
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Drinks"
        navigationController?.navigationBar.tintColor = .black
        // setup filterBarButton
        filterBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(tappedFilterBarButton))
        filterBarButton.tintColor = .gray
        navigationItem.rightBarButtonItem = filterBarButton
    }
    
    private func setupPresenter() {
        presenter = CocktailListPresenter(self)
        progressHUD.show(animated: true)
        presenter.getCocktailCategories()
    }
    
    @objc private func tappedFilterBarButton() {
        presentCategoriesViewController()
    }

    private func scrollToTop() {
        tableView.reloadData()
        if let numberOfprintCategories = presenter.printCategories?.count, numberOfprintCategories > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.scrollToRow(at: indexPath, at: .none, animated: false)
        }
    }
    
    // MARK: Navigation
    private func presentCategoriesViewController() {
        let dvc = CategoriesListViewController()
        let dvcPresenter = CategoriesListPresenter(dvc, categories: presenter.getCategoriesWithStatus())
        dvc.presenter = dvcPresenter
        navigationController?.pushViewController(dvc, animated: true)
    }
}

// MARK: - Presenter

extension CocktailListViewController: CocktailListView {
    
    func gotCocktailCategories(error: Error?) {
        progressHUD.hide(animated: true)
        if let error = error {
            print(error)
            return
        }
    }
    
    func gotCocktails(completion: (() -> ())?, error: Error?) {
        progressHUD.hide(animated: true)
        if let error = error {
            print(error)
            return
        }
        if completion == nil {
            tableView.reloadData()
        } else {
            scrollToTop()
        }
    }
    
    func didChangedPrintCategories(withLoadNewCocktails isLoading: Bool) {
        if isLoading {
            progressHUD.show(animated: true)
        } else {
            scrollToTop()
        }
        let buttonColor = getRightTextColor()
        filterBarButton.tintColor = (presenter.printCategories == presenter.categoriesTitles) ? .gray : buttonColor
    }
}

// MARK: - UITableViewDataSource

extension CocktailListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }
    
    // MARK: Categories
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter?.printCategories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        presenter.printCategories?[section].uppercased()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let creator = HeaderInSection()
        let text = self.tableView(tableView, titleForHeaderInSection: section)
    
        return creator.getStyledHeader(with: text)
    }
    
    // MARK: Cocktails
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard
            let category = presenter.printCategories?[section],
            let numberOfcoctails = presenter.cocktails[category]?.count else { return 0 }
        
        return numberOfcoctails
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cocktailCell", for: indexPath) as? CocktailTableViewCell else { return UITableViewCell() }
        
     
        if let category = presenter.printCategories?[indexPath.section],
            let cocktails = presenter.cocktails[category] {
            
            let currentCocktail = cocktails[indexPath.row]
            cell.titleLabel.text = currentCocktail.strDrink
            let urlImage = URL(string: currentCocktail.strDrinkThumb + "/preview")
            cell.photoImageView.sd_setImage(with: urlImage,
                                            placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
        return cell
    }
    
    // MARK: Pagination
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
                
        if presenter.performPagination(for: indexPath.row, section: indexPath.section) {
            progressHUD.show(animated: true)
        }
    }
}

// MARK: - UITableViewDelegate

extension CocktailListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
