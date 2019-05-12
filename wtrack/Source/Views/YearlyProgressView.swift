//
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import UIKit

struct YearlyProgressViewModel {
    let distanceRan: Float
    let goalDistance: Float
}

class YearlyProgressView: PanelView {

    // MARK: - Private properties

    private let viewModel: YearlyProgressViewModel

    // MARK: - UI properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .title4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Yearly progress"
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(Int(viewModel.distanceRan)) / \(Int(viewModel.goalDistance))"
        return label
    }()

    private lazy var progressBar: ProgressBarView = {
        let progress = ProgressBarView(doneColor: .candyGreen, progress: CGFloat(viewModel.distanceRan / viewModel.goalDistance))
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        fatalError()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    init(viewModel: YearlyProgressViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()

        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        let fraction = CGFloat(day) / 365.0
        progressBar.markerFraction = fraction
    }

    private func setup() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(progressBar)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: subtitleLabel.leadingAnchor, constant: -.mediumLargeSpacing),

            subtitleLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: .smallSpacing),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            progressBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumLargeSpacing),
            progressBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            progressBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}

