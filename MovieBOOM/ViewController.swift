//
//  ViewController.swift
//  MovieBOOM
//
//  Created by Muis on 22/08/20.
//  Copyright © 2020 Muis. All rights reserved.
//

import UIKit
// import AttributedLib
// import CHIPageControl
// import CommonCrypto
// import Darwin
// import DifferenceKit
// import DropDown
// import Floaty
// import Foundation
// import IQKeyboardManager
// import ImageSlideshow
// import JGProgressHUD
// import KeychainAccess
// import Kingfisher
// import Macaw
// import MaterialComponents
// import MidtransKit
// import Moya
// import Nantes
// import NavigationDrawer
// import PaperTrailLumberjack
// import ReSwift
// import ReSwiftThunk
// import Rswift
// import RxCocoa
// import RxSwift
// import Sentry
// import SwiftyImage
// import SwiftyJSON
// import TinyConstraints
// import UIKit
import ViewDSL
// import WebKit
// import XLPagerTabStrip

class ViewController: UIViewController {

    private let url = URL(string: "https://user-images.githubusercontent.com/1567433/59150381-d34beb80-8a22-11e9-8d9a-6b1527ffc9e1.png")!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        
        view.add { (v: UIView) in
          v.backgroundColor = .red
          v.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
          v.center = view.center
        }
    }
}

