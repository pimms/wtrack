//
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import UIKit

class ProgressBarView: UIView {

    // MARK: - Private properties

    private let doneColor: UIColor
    private let remainingColor: UIColor
    private let progress: CGFloat

    // MARK: - UI properties

    private lazy var fullBar: BarView = {
        let bar = BarView(color: remainingColor)
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    private lazy var doneBar: BarView = {
        let bar = BarView(color: doneColor)
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
}
