//
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import Foundation

public protocol Progress {
    var currentValue: Double { get }
    var goalValue: Double { get }
}

public struct SimpleProgress: Progress {
    public let currentValue: Double
    public let goalValue: Double

    public init(currentValue: Double, goalValue: Double) {
        self.currentValue = currentValue
        self.goalValue = goalValue
    }
}
