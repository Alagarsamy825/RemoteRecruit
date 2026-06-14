//
//  ViewController.swift
//  RemoteRecruit
//
//  Created by Alagarsamy on 11/06/26.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = JobListViewModel(service: JobService())
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var jobListTableview: UITableView!
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "No Jobs Found"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI setup
        setupNavigation(title: "Job Details")
        configureSearchBar()
        setupLoader()
        setupEmptyView()
        
        self.jobListTableview.keyboardDismissMode = .onDrag
        self.jobListTableview.separatorStyle = .none
        
        stateChangeUpdate()
        
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
    
    private func setupLoader() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }
    
    private func setupEmptyView() {
        emptyStateLabel.frame = view.bounds
        view.addSubview(emptyStateLabel)
    }
    
    private func stateChangeUpdate() {
        viewModel.onStateChange = { [weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch state {

                case .loading:
                    self.activityIndicator.startAnimating()
                    self.emptyStateLabel.isHidden = true
                    self.jobListTableview.isHidden = true

                case .loaded:
                    self.activityIndicator.stopAnimating()
                    self.emptyStateLabel.isHidden = true
                    self.jobListTableview.isHidden = false
                    self.jobListTableview.reloadData()

                case .empty:
                    self.activityIndicator.stopAnimating()
                    self.jobListTableview.isHidden = true
                    self.emptyStateLabel.isHidden = false

                case .error(let message):
                    self.activityIndicator.stopAnimating()
                    self.showError(message)
                }
            }
        }
    }
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchJob(with: searchText)
        DispatchQueue.main.async {
            self.jobListTableview.reloadData()
        }
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
