//
//  JobListViewModel.swift
//  RemoteRecruit
//
//  Created by Alagarsamy on 11/06/26.
//

import Foundation

final class JobListViewModel {
    private let service: JobServiceProtocol
    
    var jobs: [Job] = []
    var filteredJobs: [Job] = []
    
    init(service: JobServiceProtocol) {
        self.service = service
    }
    
    func loadJob() async throws {
        jobs = try await service.fetchJob().jobs
        filteredJobs = jobs
    }
    
    func searchJob(with text: String) {
        guard !text.isEmpty else {
            filteredJobs = jobs
            return
        }
        
        filteredJobs = jobs.filter {
            $0.title.localizedCaseInsensitiveContains(text) || $0.company.localizedCaseInsensitiveContains(text)
        }
    }
}
