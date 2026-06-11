//
//  ViewController.swift
//  RemoteRecruit
//
//  Created by Alagarsamy on 11/06/26.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = JobListViewModel(service: JobService())

    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            try? await viewModel.loadJob()
            DispatchQueue.main.async {
                print(self.viewModel.filteredJobs)
            }
            
        }
    }


}

