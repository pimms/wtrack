//
// Copyright (c) 2019 Joakim Stien. All rights reserved.
//

import UIKit
import HealthKit

class RootStateController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presentAuthorizationViewController()
    }

    // MARK: - Private methods

    private func presentAuthorizationViewController() {
        let authVc = AuthorizationViewController()
        authVc.delegate = self
        add(authVc)
    }
}

extension RootStateController: AuthorizationViewControllerDelegate {
    func authorizationViewController(_ vc: AuthorizationViewController, configuredStore store: HKHealthStore) {
        remove(vc)

        let mainVc = MainViewController()
        add(mainVc)
    }
}
