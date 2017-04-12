//
//  InstagramController.swift
//  InstagramLogin
//
//  Created by Bao Nguyen on 4/12/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import UIKit
import SVProgressHUD

class InstagramController: UIViewController, UIWebViewDelegate {

    @IBOutlet private weak var webView: UIWebView!
    
    private let clientId = "cee8a8da86254a619933a45b0686ec92"
    private let redirectUri = "http://www.instagramLogin.com/"
    private let baseUrl = "https://api.instagram.com/oauth/authorize/?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let instaAuthUrlString = "\(baseUrl)client_id=\(clientId)&redirect_uri=\(redirectUri)&response_type=token"
        guard let url = NSURL(string: instaAuthUrlString) else {
            return
        }
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
        webView.loadRequest(URLRequest(url: url as URL))
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let absoluteString = request.url?.absoluteString {
            let urlParts = absoluteString.components(separatedBy: "#access_token=")
            if urlParts.count > 1, let access_token = urlParts.last {
                print("access_token: \(access_token)\n\n")
                // Save user access token
                UserDefaults.standard.set(access_token, forKey: ACCESS_TOKEN)
                UserDefaults.standard.synchronize()
                return false
            }
        }
        return true
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("webViewDidFinishLoad")
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Error: \(error.localizedDescription)")
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }

}
