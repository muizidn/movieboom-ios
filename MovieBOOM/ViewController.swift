//
//  ViewController.swift
//  MovieBOOM
//
//  Created by Muis on 22/08/20.
//  Copyright © 2020 Muis. All rights reserved.
//

import UIKit
// import ViewDSL
import TinyConstraints

class ViewController: UIViewController {

    private let url = URL(string: "https://user-images.githubusercontent.com/1567433/59150381-d34beb80-8a22-11e9-8d9a-6b1527ffc9e1.png")!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        // view.add { (v: UIImageView) in
        //     v.frame = CGRect(origin: .zero,
        //                      size: CGSize(
        //                         width: 100,
        //                         height: 100))
        //     v.backgroundColor = .red
        //     v.center = view.center
        // }

        view.height(10)
    }


}

