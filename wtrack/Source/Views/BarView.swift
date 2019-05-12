//
// Created by pimms on 2019-05-12.
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import UIKit

class BarView: UIView {

    // MARK: - Static properties

    static let barHeight: CGFloat = 5.0

    // MARK: - Init

    init(color: UIColor) {
        super.init(frame: .zero)
        backgroundColor = color
        layer.cornerRadius = BarView.barHeight / 2.0

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: BarView.barHeight)
        ])
    }

    override init(frame: CGRect) {
        fatalError()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
