//
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import UIKit

class ProgressBar: UIView {

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

    // MARK: - Private properties

    private let doneColor: UIColor
    private let remainingColor: UIColor
    private let progress: CGFloat

    // MARK: - UI properties

    private lazy var fullBar: Bar = {
        let bar = Bar(color: remainingColor)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    private lazy var doneBar: Bar = {
        let bar = Bar(color: doneColor)
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
        fatalError()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    init(doneColor: UIColor, remainingColor: UIColor = .steel, progress: CGFloat) {
        self.doneColor = doneColor
        self.remainingColor = remainingColor
        self.progress = {
            if progress < 0 {
                return 0
            } else if progress > 1 {
                return 1
            } else {
                return progress
            }
        }()
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        addSubview(fullBar)
        addSubview(doneBar)

        fullBar.fillInSuperview()

        NSLayoutConstraint.activate([
            doneBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            doneBar.topAnchor.constraint(equalTo: topAnchor),
            doneBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            doneBar.widthAnchor.constraint(equalTo: fullBar.widthAnchor, multiplier: progress)
        ])
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

        let origin = fullBar.frame.origin
        let position = CGPoint(x: origin.x - 1.0 + fraction*fullBar.frame.width,
                               y: origin.y + 0.5*fullBar.frame.height)
        markerLayer.position = position
    }
}
