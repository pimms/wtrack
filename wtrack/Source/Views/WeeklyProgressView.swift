//
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import UIKit

class WeeklyProgressView: PanelView {

    // MARK: - Private properties

    private let progress: Progress

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
        label.text = "\(Int(progress.currentValue)) / \(Int(progress.goalValue)) km"
        return label
    }()

    private lazy var progressBar: ProgressBarView = {
        let bar = ProgressBarView(doneColor: .candyGreen, progress: CGFloat(progress.currentValue / progress.goalValue))
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    required init(progress: Progress) {
        self.progress = progress
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
        let fraction = progress.currentValue / progress.goalValue
        if fraction > 1.0001 {
            progressBar.markerFraction = 1.0 / CGFloat(fraction)
        }
    }
}
