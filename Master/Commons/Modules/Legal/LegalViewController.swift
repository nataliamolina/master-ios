//
//  LegalViewController.swift
//  Master
//
//  Created by Carlos Mejía on 1/03/20.
//  Copyright © 2020 Master. All rights reserved.
//

import UIKit
import WebKit

struct LegalViewModel {
    let baseURL = "https://masterapp.com.co/legal/"
    
    var termsURL: String {
        return baseURL + "terms"
    }
    
    var privacyURL: String {
        return baseURL + "privacy"
    }
}

class LegalViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var termsButton: MButton!
    @IBOutlet private weak var privacyButton: MButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - UI Actions
    @IBAction private func termsButtonAction() {
        termsButton.style = .green
        privacyButton.style = .greenBorder
        
        loadUrl(viewModel.termsURL)
    }
    
    @IBAction private func privacyButtonAction() {
        termsButton.style = .greenBorder
        privacyButton.style = .green
        
        loadUrl(viewModel.privacyURL)
    }
    
    // MARK: - Properties
    var customTitle: String?
    
    private let viewModel: LegalViewModel = {
        return LegalViewModel()
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        if let customTitle = customTitle {
            titleLabel.isHidden = true
            titleLabel.text = nil
            title = customTitle
        }
        
        webView.navigationDelegate = self
        
        termsButtonAction()
    }
    
    private func loadUrl(_ url: String) {
        guard let urlToRequest = URL(string: url) else {
            return
        }
        
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as? Set<String> ?? [],
                                                modifiedSince: date,
                                                completionHandler: {})
        
        webView.load(URLRequest(url: urlToRequest))
    }
}

// MARK: - WKUIDelegate
extension LegalViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Loader.dismiss()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Loader.show()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Loader.dismiss()
    }
}
