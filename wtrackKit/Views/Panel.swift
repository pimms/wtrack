//
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import UIKit

public class Panel: UIView {

    // MARK: - Init

    init() {
        super.init(frame: .zero)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    private func setup() {
        backgroundColor = .systemBackground
        layer.borderColor = UIColor.systemGray3.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = .mediumLargeSpacing
        translatesAutoresizingMaskIntoConstraints = false

        /* Shadows inside a tableview is obviously shit, so solve that
         * before potentially enabling shadows again.
        layer.shadowColor = UIColor(white: 0, alpha: 1.0).cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        layer.shadowOffset = .zero

        layer.masksToBounds = false
        clipsToBounds = false
        */
    }
}

