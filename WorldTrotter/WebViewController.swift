//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Bobby Hamrick on 2/2/17.
//  Copyright © 2017 Bobby Hamrick. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate{
    
    //create view for web kit view
    var webView: WKWebView!
    
    override func loadView(){
        webView = WKWebView()
        
        view = webView
        
        let url = URL(string: "https://www.bignerdranch.com")!
        webView.load(URLRequest(url: url))
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("WebViewController loaded its view")
    }
}
