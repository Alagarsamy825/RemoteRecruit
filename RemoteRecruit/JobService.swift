//
//  JobService.swift
//  RemoteRecruit
//
//  Created by Alagarsamy on 11/06/26.
//

import Foundation

protocol JobServiceProtocol {
    func fetchJob() async throws -> Jobs
}

final class JobService: JobServiceProtocol {
    func fetchJob() async throws -> Jobs {
        guard let url = Bundle.main.url(forResource: "jobs", withExtension: "json") else {
            throw NSError()
        }
        
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(Jobs.self, from: data)
    }
}
