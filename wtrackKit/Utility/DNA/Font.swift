//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
//  Later shamelessly axed to pieces by me.
//

import UIKit

extension UIFont {
    static var title1: UIFont {
        return UIFont.boldSystemFont(ofSize: 34.0)
    }

    static var title2: UIFont {
        return UIFont.boldSystemFont(ofSize: 28.0)
    }

    static var title3: UIFont {
        return UIFont.boldSystemFont(ofSize: 22)
    }

    static var body: UIFont {
        return UIFont.systemFont(ofSize: 16)
    }

    static var bodyStrong: UIFont {
        return UIFont.boldSystemFont(ofSize: 16)
    }

    static var detail : UIFont {
        return UIFont.italicSystemFont(ofSize: 14)
    }
}
