# RemoteRecruit
A simple iOS application that allows users to browse, search, and view job details.

## Requirements
* Xcode 26.1.1
* iOS 17+
* Swift 5+

## Architecture
The application follows the MVVM (Model-View-ViewModel) architecture.

### Layers
**Model**
* Job model

**View**
* JobListViewController
* JobDetailViewController
* JobListTableViewCell

**ViewModel**
* JobListViewModel

**Service**
* JobService

### State Handling
The application handles the following states:
* Loading
* Success
* Empty
* Error

### Dependency Injection
Services are injected into ViewModels using protocols to improve testability.

## Testing
Unit tests are included for:
* JobListViewModel
* JobService

Mock services are used to verify business logic.

## Assumptions
* Job data is loaded from a local JSON file.
* Search is performed locally on the downloaded dataset.
* Pagination is not implemented as it is outside the scope of the assignment.
* Company logos and remote image loading are not included.
* Network connectivity is not required because local mock data is used.

## Features
* Browse job listings
* Search by job title
* Search by company name
* View detailed job information
* Loading state handling
* Empty state handling
* Error state handling
* Unit tests
