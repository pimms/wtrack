//
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import UIKit
import HealthKit

protocol AuthorizationViewControllerDelegate: AnyObject {
    func authorizationViewController(_ vc: AuthorizationViewController, configuredStore store: HKHealthStore)
}

class AuthorizationViewController: UIViewController {

    // MARK: - Private properties

    private let healthStore = HKHealthStore()

    // MARK: - Internal properties

    weak var delegate: AuthorizationViewControllerDelegate?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        requestAccess()
    }

    // MARK: - Private methods

    private func requestAccess() {
        let toRead = Set(arrayLiteral: HKWorkoutType.workoutType())

        healthStore.requestAuthorization(toShare: nil, read: toRead, completion: { [weak self] success, err in
            if success, let self = self {
                print("SUCCESS! :D")
                self.delegate?.authorizationViewController(self, configuredStore: self.healthStore)
            } else {
                print("FAILURE! :(")
                print("Err: \(err)")
            }
        })
    }
}
