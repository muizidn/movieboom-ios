//
//  ViewController.swift
//  BazelAppDev
//
//  Created by Muis on 22/08/20.
//  Copyright © 2020 Muis. All rights reserved.
//

import UIKit
import RxSwift
import ViewDSL
import TinyConstraints

class ViewController: UIViewController {

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        view.add { (v: UIView) in
            v.frame = CGRect(origin: .zero,
                             size: CGSize(
                                width: 100,
                                height: 100))
            v.center = view.center
            v.backgroundColor = .red
        }
    }


}

