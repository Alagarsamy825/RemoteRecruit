//
//  Job.swift
//  RemoteRecruit
//
//  Created by Alagarsamy on 11/06/26.
//

import Foundation

struct Jobs: Codable {
    let jobs: [Job]
}

struct Job: Codable {
    let id: String
    let title: String
    let company: String
    let location: String
    let salaryRange: String
    let description: String
    let companyInfo: String
    let jobLocation: String
}
