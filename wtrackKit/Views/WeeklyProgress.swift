//
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import UIKit

public struct WeeklyProgressViewModel {
    public let goalDistance: Double
    public let weeklyDistances: [Double]
    public var distance: Double {
        return weeklyDistances.reduce(0, +)
    }

    public init(goalDistance: Double, weeklyDistances: [Double]) {
        self.goalDistance = goalDistance
        self.weeklyDistances = weeklyDistances
    }
}

public class WeeklyProgress: Panel {

    // MARK: - Private properties

    private let viewModel: WeeklyProgressViewModel

    // MARK: - UI properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .title4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Weekly progress"
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(Int(viewModel.distance)) / \(Int(viewModel.goalDistance)) km"
        return label
    }()

    private lazy var progressBar: MultiSegmentProgressBar = {
        let bar = MultiSegmentProgressBar(rawSegmentValues: viewModel.weeklyDistances, goalValue: viewModel.goalDistance)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public required init(viewModel: WeeklyProgressViewModel) {
        self.viewModel = viewModel
        super.init()
        setup()
        setupMarker()
    }

    private func setup() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(progressBar)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: subtitleLabel.leadingAnchor, constant: -.mediumLargeSpacing),

            subtitleLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            progressBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumLargeSpacing),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            progressBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),
        ])
    }

    private func setupMarker() {
        let fraction = viewModel.distance / viewModel.goalDistance
        if fraction > 1.0001 {
            progressBar.markerFraction = 1.0 / CGFloat(fraction)
        }
    }
}
