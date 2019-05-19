//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public extension UIView {
    /// Layouts the current view to fit it's superview.
    ///
    /// - Parameters:
    ///   - insets: The inset for fitting the superview.
    ///   - isActive: A boolean on whether the constraint is active or not.
    /// - Returns: The added constraints.
    @discardableResult
    func fillInSuperview(insets: UIEdgeInsets = .zero, isActive: Bool = true) -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            return [NSLayoutConstraint]()
        }

        translatesAutoresizingMaskIntoConstraints = false

        var constraints = [NSLayoutConstraint]()
        constraints.append(topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top))
        constraints.append(leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left))
        constraints.append(bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom))
        constraints.append(trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: insets.right))

        if isActive {
            NSLayoutConstraint.activate(constraints)
        }

        return constraints
    }

    /// Locks the view's aspect ratio
    ///
    /// - Parameters:
    ///   - ratio: Aspect ratio; width divided by height.
    ///   - isActive: Whether to activate the constraint or not
    /// - Returns: The added constraint
    @discardableResult
    func constrainAspectRatio(_ ratio: CGFloat, isActive: Bool = true) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false

        let constraint = heightAnchor.constraint(equalTo: widthAnchor, multiplier: ratio, constant: 0.0)

        if isActive {
            NSLayoutConstraint.activate([constraint])
        }

        return constraint
    }
}
