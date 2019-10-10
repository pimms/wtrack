//
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import UIKit

class ProgressBarBase: UIView {

    // MARK: - Internal properties

    var markerFraction: CGFloat? {
        didSet {
            if markerFraction == nil {
                markerLayer.isHidden = true
            } else {
                updateMarkerLayer()
            }
        }
    }

    // MARK: - UI properties

    fileprivate lazy var backgroundBar: Bar = {
        let bar = Bar(color: .gray)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    private lazy var markerLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.darkGray.cgColor
        layer.bounds = CGRect(x: 0, y: 0, width: 1.0, height: Bar.barHeight + 4.0)
        layer.cornerRadius = 1.0
        return layer
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        addSubview(backgroundBar)
        backgroundBar.fillInSuperview()
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        if markerFraction != nil {
            updateMarkerLayer()
        }
    }

    // MARK: - Private methods

    private func updateMarkerLayer() {
        guard let fraction = markerFraction else {
            markerLayer.isHidden = true
            return
        }

        markerLayer.isHidden = false
        if markerLayer.superlayer == nil {
            layer.addSublayer(markerLayer)
        }

        let origin = backgroundBar.frame.origin
        let position = CGPoint(x: origin.x - 1.0 + fraction*backgroundBar.frame.width,
            y: origin.y + 0.5*backgroundBar.frame.height)
        markerLayer.position = position
    }
}

// MARK: - ProgressBar

class ProgressBar: ProgressBarBase {

    // MARK: - Private properties

    private let progressColor: UIColor
    private let progress: CGFloat

    // MARK: - UI properties

    private lazy var progressBar: Bar = {
        let bar = Bar(color: progressColor)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        fatalError()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    init(progressColor: UIColor, progress: CGFloat) {
        self.progressColor = progressColor
        self.progress = {
            if progress < 0 {
                return 0
            } else if progress > 1 {
                return 1
            } else {
                return progress
            }
        }()
        super.init()
        setup()
    }

    private func setup() {
        addSubview(progressBar)

        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressBar.topAnchor.constraint(equalTo: topAnchor),
            progressBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressBar.widthAnchor.constraint(equalTo: backgroundBar.widthAnchor, multiplier: progress)
        ])
    }
}

// MARK: - MultiSegmentProgressBar

class MultiSegmentProgressBar: ProgressBarBase {
    var rawSegmentValues: [Double] { didSet { resetBars() } }
    var goalValue: Double? { didSet { updateGoalMarker() } }

    private var bars: [Bar] = []

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    required init(rawSegmentValues: [Double], goalValue: Double?) {
        self.rawSegmentValues = rawSegmentValues
        self.goalValue = goalValue
        super.init(frame: .zero)

        updateGoalMarker()
        setupBars()
    }

    private func resetBars() {
        removeBars()
        setupBars()
    }

    private func removeBars() {
        backgroundBar.subviews.forEach { $0.removeFromSuperview() }
    }

    private func setupBars() {
        let sum = rawSegmentValues.reduce(0, +)
        let widthDenominator = max(goalValue ?? sum, sum)

        let fractionValues = rawSegmentValues.map { CGFloat($0 / widthDenominator) }
        let colors = colorArray()
        var index: Int = 0
        var trailingEdgeAnchor = backgroundBar.leadingAnchor

        for segmentFraction in fractionValues {
            let color = colors[index % colors.count]
            index += 1

            let bar = Bar(color: color)
            bar.translatesAutoresizingMaskIntoConstraints = false
            backgroundBar.addSubview(bar)

            NSLayoutConstraint.activate([
                bar.leadingAnchor.constraint(equalTo: trailingEdgeAnchor),
                bar.topAnchor.constraint(equalTo: backgroundBar.topAnchor),
                bar.bottomAnchor.constraint(equalTo: backgroundBar.bottomAnchor),
                bar.widthAnchor.constraint(equalTo: backgroundBar.widthAnchor, multiplier: segmentFraction)
            ])

            trailingEdgeAnchor = bar.trailingAnchor
        }
    }

    private func updateGoalMarker() {
        let sum = rawSegmentValues.reduce(0, +)

        if let goal = goalValue, sum > goal {
            markerFraction = CGFloat(goal / sum)
        } else {
            markerFraction = nil
        }
    }

    private func colorArray() -> [UIColor] {
        let colors: [UIColor] = [ .systemYellow, .systemBlue, .systemGreen, .systemPink ]

        let rounded = rawSegmentValues.map { Int($0) }
        let seed = rounded.reduce(0, +)
        var rng = SeedableRNG(seed: seed)

        return colors.shuffled(using: &rng)
    }
}
