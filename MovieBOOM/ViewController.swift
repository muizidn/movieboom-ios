//
//  ViewController.swift
//  MovieBOOM
//
//  Created by Muis on 22/08/20.
//  Copyright © 2020 Muis. All rights reserved.
//

import UIKit
import ViewDSL
import NeedleFoundation
import Starscream
import Apollo

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

class Network {
  static let shared = Network() 
    
  private(set) lazy var apollo = ApolloClient(url: URL(string: "http://localhost:8080/graphql")!)
}

var myws: WebSocket!

func Starscreams() {
  var request = URLRequest(url: URL(string: "http://localhost:8080")!)
  request.timeoutInterval = 5
  myws = WebSocket(request: request)
  myws.connect()
}