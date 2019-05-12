//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit
import HealthKit

class MainViewController: UIViewController {

    // MARK: - Private properties

    private let workoutRepository: WorkoutRepository

    // MARK: - UI properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .title1
        label.text = "Run Tracker"
        return label
    }()

    // MARK: - Init

    init(workoutRepository: WorkoutRepository) {
        self.workoutRepository = workoutRepository
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
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}

