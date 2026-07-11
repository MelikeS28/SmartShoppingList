//
//  ViewController.swift
//  SmartShoppingList
//
//  Created by Melike on 22.06.2026.
//

import UIKit
import SnapKit


class ViewController: UIViewController {

 let viewModel = ViewModel()
// MARK: - UI Elements
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ShoppingCell")
        return tableView
    }()
   
    
// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupNavigation()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
// MARK: - Getdata
    
    private func getData() {
        viewModel.fetchData()
        tableView.reloadData()
        
        DispatchQueue.main.async {
                self.tableView.reloadData()
        }
    }
// MARK: - SetupViews
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Smart Shopping List"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemPurple]
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
// MARK: - SetupNavigation
    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonClicked)
        )
    }
// MARK: - Actions
    @objc private func addButtonClicked() {
        let detailVC = DetailsViewController()
        detailVC.title = "Add Product"
        
        detailVC.viewModel.delegate = self.viewModel
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
// MARK: - SetupConstraints
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
// MARK: - UITableViewDelegate
    
    extension ViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            print("\(indexPath.row). satıra tıklandı.")
            let selectedItem = viewModel.shoppingItems[indexPath.row]
            let detailVC = DetailsViewController()
            detailVC.title = selectedItem.name
            detailVC.viewModel.chosenShoppingItem = selectedItem
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
// MARK: - UITableViewDataSource
    extension ViewController: UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.shoppingItems.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingCell", for: indexPath)
            let currentItem = viewModel.shoppingItems[indexPath.row]
            cell.textLabel?.text = currentItem.name
            return cell
        }
        
    }

