//
//  JobListTableViewCell.swift
//  RemoteRecruit
//
//  Created by Alagarsamy on 11/06/26.
//

import UIKit

class JobListTableViewCell: UITableViewCell {

    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var jobTitle: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var salaryRange: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ job: Job) {
        companyName.text = job.company
        jobTitle.text = job.title
        location.text = job.location
        salaryRange.text = job.salaryRange
        print(job)
    }

}
