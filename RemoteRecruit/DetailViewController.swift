//
//  DetailViewController.swift
//  RemoteRecruit
//
//  Created by Alagarsamy on 12/06/26.
//

import UIKit

class DetailViewController: UIViewController {
    
    var job: Job!

    @IBOutlet weak var jobDescriptionLabel: UILabel!
    @IBOutlet weak var companyInfoLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        setupUI()
    }
    
    func setupUI() {
        self.jobDescriptionLabel.text = job.description
        self.companyInfoLabel.text = job.companyInfo
        self.locationLabel.text = job.location
        self.salaryLabel.text = job.salaryRange
    }

}
