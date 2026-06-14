//
//  JobListViewModel.swift
//  RemoteRecruit
//
//  Created by Alagarsamy on 11/06/26.
//

import Foundation

enum JobListState {
    case loading
    case loaded
    case empty
    case error(String)
}

final class JobListViewModel {
    private let service: JobServiceProtocol
    
    var jobs: [Job] = []
    var filteredJobs: [Job] = []
    
    var onStateChange: ((JobListState) -> Void)?
    
    init(service: JobServiceProtocol) {
        self.service = service
    }
    
    func loadJob() async {
        onStateChange?(.loading)
        do {
            jobs = try await service.fetchJob().jobs
            filteredJobs = jobs
            if jobs.isEmpty {
                onStateChange?(.empty)
            } else {
                onStateChange?(.loaded)
            }
        } catch {
            onStateChange?(.error(error.localizedDescription))
        }
        
    }
    
    func searchJob(with text: String) {
        guard !text.isEmpty else {
            filteredJobs = jobs
            onStateChange?(.loaded)
            return
        }
        
        filteredJobs = jobs.filter {
            $0.title.localizedCaseInsensitiveContains(text) || $0.company.localizedCaseInsensitiveContains(text)
        }
        
        if filteredJobs.isEmpty {
            onStateChange?(.empty)
        } else {
            onStateChange?(.loaded)
        }
    }
}
