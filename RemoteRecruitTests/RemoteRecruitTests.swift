//
//  RemoteRecruitTests.swift
//  RemoteRecruitTests
//
//  Created by Alagarsamy on 11/06/26.
//

import XCTest
@testable import RemoteRecruit

final class MockJobService: JobServiceProtocol {

    var shouldThrowError = false
    var jobs: [Job] = []

    func fetchJob() async throws -> Jobs {

        if shouldThrowError {
            throw NSError(domain: "TestError", code: 0)
        }

        return Jobs(jobs: jobs)
    }
}

final class RemoteRecruitTests: XCTestCase {

    func testLoadJobsSuccess() async {

        let mockService = MockJobService()

        mockService.jobs = [
            Job(
                id: "1",
                title: "iOS Developer",
                company: "Google",
                location: "Chennai",
                salaryRange: "10L",
                description: "Swift",
                companyInfo: "Tech Solutions Inc. is a technology company focused on delivering high-quality digital products and services.",
                jobLocation: "Onsite"
            )
        ]

        let viewModel = await JobListViewModel(service: mockService)

        await viewModel.loadJob()

        XCTAssertEqual(viewModel.jobs.count, 1)
    }

    func testLoadJobsEmpty() async {

        let mockService = MockJobService()

        let viewModel = await JobListViewModel(service: mockService)

        var isEmptyState = false

        viewModel.onStateChange = { state in
            if case .empty = state {
                isEmptyState = true
            }
        }

        await viewModel.loadJob()

        XCTAssertTrue(isEmptyState)
    }

    func testLoadJobsError() async {

        let mockService = MockJobService()
        mockService.shouldThrowError = true

        let viewModel = await JobListViewModel(service: mockService)

        var hasError = false

        viewModel.onStateChange = { state in
            if case .error = state {
                hasError = true
            }
        }

        await viewModel.loadJob()

        XCTAssertTrue(hasError)
    }
    
    func testJobCreation() {

        let job = Job(
            id: "1",
            title: "iOS Developer",
            company: "Google",
            location: "Chennai",
            salaryRange: "10L - 15L",
            description: "Swift Developer",
            companyInfo: "Google",
            jobLocation: "Chennai"
        )

        XCTAssertEqual(job.title, "iOS Developer")
    }

    func testSearchJob() async {

        let mockService = MockJobService()
        let viewModel = await JobListViewModel(service: mockService)

        let job = Job(
            id: "1",
            title: "iOS Developer",
            company: "Google",
            location: "Chennai",
            salaryRange: "10L - 15L",
            description: "Swift Developer",
            companyInfo: "Google",
            jobLocation: "Chennai"
        )

        await viewModel.loadJob()
        
        viewModel.jobs = [job]

        viewModel.searchJob(with: "iOS")

        XCTAssertEqual(viewModel.filteredJobs.count, 1)
    }

    func testSearchNoResult() async {
//        XCTAssertTrue(true)
        let mockService = MockJobService()

        let viewModel = JobListViewModel(service: mockService)

        let job = [
            Job(
                id: "1",
                title: "iOS Developer",
                company: "Google",
                location: "Chennai",
                salaryRange: "10L",
                description: "Swift",
                companyInfo: "Tech Solutions Inc. is a technology company focused on delivering high-quality digital products and services.",
                jobLocation: "Onsite"
            )
        ]
        
        await viewModel.loadJob()
        
        viewModel.jobs = job
        viewModel.filteredJobs = job

        viewModel.searchJob(with: "Doctor")

        XCTAssertEqual(viewModel.filteredJobs.count, 0)
    }
}
