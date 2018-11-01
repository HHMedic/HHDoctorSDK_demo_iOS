//
//  CavsBrowser.swift
//  Cavs
//
//  Created by mk on 2017/10/30.
//  Copyright © 2017年 Johnson. All rights reserved.
//

import UIKit
import SnapKit
import WebKit


class WebBrowser: UIViewController, WKUIDelegate, WKNavigationDelegate
{
    let ob_progress = "estimatedProgress"
    let ob_title = "title"
    
    /// 网页url
    var urlString: String? {
        didSet {
            loadUrl()
        }
    }
    
    /// 网页名称
    var titleString: String?

    /// webView
    lazy var mWebView: WKWebView = {
        let configuretion = WKWebViewConfiguration()
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = true
//        configuretion.preferences.javaScriptEnabled = true
        let wkView = WKWebView(frame: CGRect.zero , configuration: configuretion)
        
        return wkView
        
    }()
    /// 进度条
    lazy var mProgress: UIProgressView = {
        let webPV = UIProgressView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 5))
        webPV.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        return webPV
    }()
    

    public init(URL: String, title: String = "")
    {
        self.urlString = URL
        self.titleString = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        
        initUI()
//        loadUrl()
    }

    private func initUI()
    {
        view.addSubview(mWebView)
        view.addSubview(mProgress)
    
        mWebView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        })

        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
        
        settingWeb()
    }
    
    fileprivate func settingWeb() {
        mWebView.uiDelegate = self
        mWebView.navigationDelegate = self
        mWebView.allowsBackForwardNavigationGestures = true
        mWebView.addObserver(self, forKeyPath: ob_progress, options: .new, context: nil)
        mWebView.addObserver(self, forKeyPath: ob_title, options: .new, context: nil)
    }

    func clickGoBackBtn() {
        guard mWebView.canGoBack else { clickCloseBtn(); return }
        mWebView.goBack()
    }

    @objc func clickCloseBtn() {
        guard let navVC = navigationController else { return }
        navVC.popViewController(animated: true)
    }
    
    private func loadUrl() {
        if let webURL =  URL(string: urlString ?? "") {
            let request = URLRequest(url: webURL)
            mWebView.load(request)
        }
    }
 
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let path = keyPath else { return }
        switch path
        {
        case ob_title:
            bindTitle(change)
            
        case ob_progress:
            updateProgress()
            
        default:
            
            break
        }
    }

    // 此代理方法如果不实现，则不会实现网页跳转
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        if navigationAction.targetFrame == nil
        {
            webView.load(navigationAction.request)
        }
        
        decisionHandler(.allow)
    }
    
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void)
    {
        let alertC = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alertC.addAction(UIAlertAction(title: "确定", style: .default, handler: { (aAction) in
            completionHandler()
        }))
        
        alertC.addAction(UIAlertAction(title: "取消", style: .default, handler: { (_) in
            completionHandler()
        }))
        
        present(alertC, animated: true, completion: nil)
    }
    
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        webView.canGoBack ? addCloseItem() : delCloseItem()
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print("start")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    
    private func addCloseItem()
    {
        guard navigationItem.rightBarButtonItem == nil else { return }
        let item = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(clickCloseBtn))
        item.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)], for: .normal)
        navigationItem.rightBarButtonItem = item
    }
    
    private func delCloseItem()
    {
        guard let _ = navigationItem.rightBarButtonItem else { return }
        navigationItem.rightBarButtonItem = nil
    }

    deinit {
        mWebView.removeObserver(self, forKeyPath: ob_progress)
        mWebView.removeObserver(self, forKeyPath: ob_title)
    }
}

extension WebBrowser
{
    fileprivate func bindTitle(_ change: [NSKeyValueChangeKey : Any]?)
    {
        if !(titleString ?? "").isEmpty {
            title = titleString
        } else {
            if let aDic = change {
                title = aDic[NSKeyValueChangeKey(rawValue: "new")] as? String
            }
        }
    }
    
    fileprivate func updateProgress()
    {
//        print("progress: \(mWebView.estimatedProgress)")
        mProgress.isHidden = mWebView.estimatedProgress == 1
        mProgress.setProgress(Float((mWebView.estimatedProgress)), animated: true)
    }
}
