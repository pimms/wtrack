//
//  Copyright © 2019 Joakim Stien. All rights reserved.
//

import UIKit

extension UIColor {
    public class var defaultBackground: UIColor {
        return .black
    }

    public class var inverseBackground: UIColor {
        return UIColor(r: 220, g: 220, b: 220)
    }

    public class var defaultText: UIColor {
        return .black
    }

    public class var inverseText: UIColor {
        return UIColor(r: 34, g: 34, b: 34)
    }

    // MARK: - Action button

    public class var actionButtonBackground: UIColor {
        return UIColor(r: 234, g: 155, b: 44)
    }

    public class var actionButtonBackgroundHighlight: UIColor {
        return UIColor(r: 183, g: 120, b: 31)
    }

    public class var actionButtonBackgroundDisabled: UIColor {
        return UIColor(r: 145, g: 96, b: 27)
    }


    // MARK: - Destructive button

    public class var destructiveButtonBackground: UIColor {
        return UIColor(r: 234, g: 70, b: 44)
    }

    public class var destructiveButtonBackgroundHighlight: UIColor {
        return UIColor(r: 183, g: 55, b: 31)
    }

    public class var destructiveButtonBackgroundDisabled: UIColor {
        return UIColor(r: 145, g: 30, b: 27)
    }

    // MARK: - General Palette

    public class var steel: UIColor {
        return UIColor(r: 242, g: 242, b: 242)
    }

    public class var candyPink: UIColor {
        return UIColor(r: 224, g: 49, b: 97)
    }

    public class var candyGreen: UIColor {
        return UIColor(r: 168, g: 220, b: 78)
    }
}
