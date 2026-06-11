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
        searchBar.placeholder = "Search job"
        navigationItem.title = "Job List"
        Task {
            try? await viewModel.loadJob()
            DispatchQueue.main.async {
                self.jobListTableview.reloadData()
                print(self.viewModel.filteredJobs)
            }
            
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchJob(with: searchText)
        self.jobListTableview.reloadData()
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobList") as! JobListTableViewCell
        cell.configure(viewModel.filteredJobs[indexPath.row])
        return cell
    }
    
    
}
