//
//  ViewController.swift
//  RemoteRecruit
//
//  Created by Alagarsamy on 11/06/26.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = JobListViewModel(service: JobService())
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var jobListTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation(title: "Job Details")
        configureSearchBar()
        
        self.jobListTableview.keyboardDismissMode = .onDrag
        self.jobListTableview.separatorStyle = .none
        
        Task {
            await viewModel.loadJob()
            self.jobListTableview.reloadData()
        }
    }
    
    private func configureSearchBar() {

        searchBar.searchBarStyle = .minimal
        searchBar.backgroundImage = UIImage()

        let textField = searchBar.searchTextField

        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 20
        textField.layer.masksToBounds = true

        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray5.cgColor

        textField.placeholder = "Search jobs"

        textField.leftView?.tintColor = .systemGray

        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.05
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
        textField.layer.shadowRadius = 4
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchJob(with: searchText)
        self.jobListTableview.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobList") as! JobListTableViewCell
        cell.selectionStyle = .none
        cell.configure(viewModel.filteredJobs[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.job = viewModel.filteredJobs[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
