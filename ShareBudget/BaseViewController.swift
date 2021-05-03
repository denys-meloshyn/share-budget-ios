//
//  BaseViewController.swift
//  ShareBudget
//
//  Created by Denys Meloshyn on 16.01.17.
//  Copyright © 2017 Denys Meloshyn. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var viperView: BaseViewProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureVIPER()

        linkStoryboardViews()
        viperView?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viperView?.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viperView?.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        viperView?.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        viperView?.viewDidDisappear(animated)
    }

    open func configureVIPER() {}

    func linkStoryboardViews() {}
}
