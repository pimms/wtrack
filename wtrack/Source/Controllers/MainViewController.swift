//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit
import HealthKit

class MainViewController: UIViewController {

    // MARK: - Private properties

    private let workoutRepository: WorkoutRepository
    private let goalRepository: GoalRepository

    // MARK: - UI properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Run Tracker"
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.allowsSelection = false
        return tableView
    }()

    // MARK: - Init

    init(workoutRepository: WorkoutRepository, goalRepository: GoalRepository) {
        self.workoutRepository = workoutRepository
        self.goalRepository = goalRepository
        super.init(nibName: nil, bundle: nil)

        // workoutRepository.fetchAllWorkouts()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        view.backgroundColor = .white

        view.addSubview(titleLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.mediumLargeSpacing),

            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .largeSpacing),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo:view.bottomAnchor)
        ])
    }
}

extension MainViewController: UITableViewDataSource {

    private enum TableContent: Int, CaseIterable {
        case yearlyProgress
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableContent.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        let cellContentView = contentView(forIndexPath: indexPath)
        cell.contentView.addSubview(cellContentView)
        cellContentView.fillInSuperview(insets: UIEdgeInsets(top: 0, left: .mediumLargeSpacing, bottom: 0, right: -.mediumLargeSpacing))
        return cell
    }

    private func contentView(forIndexPath indexPath: IndexPath) -> UIView {
        guard let content = TableContent.allCases.filter({ $0.rawValue == indexPath.row }).first else {
            fatalError()
        }

        switch content {
        case .yearlyProgress:
            return YearlyProgressView(viewModel: calculateYearlyProgress())
        }
    }
}

// MARK: - Yearly Progress

extension MainViewController {
    private func calculateYearlyProgress() -> YearlyProgressViewModel {
        let goalDistance = goalRepository.kilometersPerWeek * 52
        let viewModel = YearlyProgressViewModel(distanceRan: 100, goalDistance: Float(goalDistance))
        return viewModel
    }
}
