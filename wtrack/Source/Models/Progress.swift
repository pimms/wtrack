//
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import Foundation

protocol Progress {
    var currentValue: Float { get }
    var goalValue: Float { get }
}

struct SimpleProgress: Progress {
    let currentValue: Float
    let goalValue: Float
}