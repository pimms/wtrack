//
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import Foundation

protocol Progress {
    var currentValue: Double { get }
    var goalValue: Double { get }
}

struct SimpleProgress: Progress {
    let currentValue: Double
    let goalValue: Double
}
