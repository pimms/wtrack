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
        tableView.delegate = self
        tableView.allowsSelection = false
        return tableView
    }()

    // MARK: - Init

    init(workoutRepository: WorkoutRepository, goalRepository: GoalRepository) {
        self.workoutRepository = workoutRepository
        self.goalRepository = goalRepository
        super.init(nibName: nil, bundle: nil)
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

    // MARK: - Public methods

    func reloadWorkoutData() {
        print("[MainViewController] Reloading workout data")
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource {

    private enum TableContent: Int, CaseIterable {
        case weeklyProgress
        case yearlyProgress
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return TableContent.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        let cellContentView = contentView(forIndexPath: indexPath)
        cell.contentView.addSubview(cellContentView)
        cellContentView.fillInSuperview(insets: UIEdgeInsets(top: 0, left: .mediumLargeSpacing, bottom: 0, right: -.mediumLargeSpacing))
        return cell
    }

    private func contentView(forIndexPath indexPath: IndexPath) -> UIView {
        guard let content = TableContent.allCases.filter({ $0.rawValue == indexPath.section }).first else {
            fatalError()
        }

        switch content {
        case .yearlyProgress:
            return YearlyProgress(progress: calculateYearlyProgress())
        case .weeklyProgress:
            return WeeklyProgress(progress: calculateWeeklyProgress())
        }
    }
}

extension MainViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .mediumLargeSpacing
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}

// MARK: - Progress Calculation

extension MainViewController {
    private func calculateYearlyProgress() -> Progress {
        let goalDistance = (Double(goalRepository.kilometersPerWeek) / 7.0) * 364.0
        let curDistance = workoutRepository.totalKilometersThisYear
        let progress = SimpleProgress(currentValue: curDistance, goalValue: Float(goalDistance))
        return progress
    }

    private func calculateWeeklyProgress() -> Progress {
        let goalDistance = goalRepository.kilometersPerWeek
        let curDistance = workoutRepository.totalKilometersThisWeek
        let progress = SimpleProgress(currentValue: curDistance, goalValue: Float(goalDistance))
        return progress
    }
}
