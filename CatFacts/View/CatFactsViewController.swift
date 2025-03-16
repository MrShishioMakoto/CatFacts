//
//  ViewController.swift
//  CatFacts
//
//  Created by Kerem Gunduz on 30/03/2021.
//

import UIKit
import Combine

class CatFactsViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let viewModel = CatFactsViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        viewModel.fetchCatFacts()
    }
    
    private func configureUI() {
        self.searchBar.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.register(CatFactCell.nib(), forCellReuseIdentifier: CatFactCell.identifier)
    }
    
    private func bindViewModel() {
        viewModel.$filteredCatFacts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in
                if loading {
                     self?.activityIndicator.startAnimating()
                } else {
                     self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let error = error else { return }
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
            .store(in: &cancellables)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension CatFactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCatFacts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CatFactCell", for: indexPath) as? CatFactCell,
              let catFact = viewModel.catFact(at: indexPath.row)
        else { return UITableViewCell() }
        
        let cellViewModel = CatFactCellViewModel(
            factDescription: catFact.text,
            isVerified: catFact.status.verified,
            isNew: catFact.isNew
        )
        
        cell.configure(cellViewModel)
        return cell
    }
}

extension CatFactsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterCatFacts(by: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
