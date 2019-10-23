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

let ob_progress = "estimatedProgress"
let ob_title = "title"

class HHWebBrowser: UIViewController, WKUIDelegate, WKNavigationDelegate {
    /// 网页url
    var urlString: String?
//    {
//        didSet {
//            loadUrl()
//        }
//    }
    
    /// 网页名称
    var titleString: String?

    /// webView
    lazy var mWebView: WKWebView = {
        let configuretion = WKWebViewConfiguration()
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = true
        let wkView = WKWebView(frame: CGRect.zero , configuration: configuretion)
        
        return wkView
        
    }()
    /// 进度条
    lazy var mProgress: UIProgressView = {
        let webPV = UIProgressView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 5))
        webPV.transform = CGAffineTransform(scaleX: 1.0, y: 2.0)
        return webPV
    }()
    
    private var navi: UINavigationController?
    private var gesDelegate: UIGestureRecognizerDelegate?
    
    
    
    init(_ URL: String, title: String = "") {
        self.urlString = URL
        self.titleString = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        print("122222")
        
        self.navi = self.navigationController
        self.gesDelegate = self.navigationController?.interactivePopGestureRecognizer?.delegate
    }

    private func initUI() {
        view.addSubview(mWebView)
        view.addSubview(mProgress)
    
        mWebView.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        })

        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_app2"), style: .done, target: self, action: #selector(clickGoBackBtn))
//        navigationItem.leftBarButtonItem?.target = self
//        navigationItem.leftBarButtonItem?.action = #selector(clickGoBackBtn)
        
        settingWeb()
        
        loadUrl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navi?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navi?.interactivePopGestureRecognizer?.delegate = self.gesDelegate
    }
    
    fileprivate func settingWeb() {
        mWebView.uiDelegate = self
        mWebView.navigationDelegate = self
        mWebView.allowsBackForwardNavigationGestures = true
        mWebView.addObserver(self, forKeyPath: ob_progress, options: .new, context: nil)
        mWebView.addObserver(self, forKeyPath: ob_title, options: .new, context: nil)
    }

    @objc func clickGoBackBtn() {
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
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.targetFrame == nil {
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
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        print("runJavaScriptConfirmPanelWithMessage")

        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (_) in
            completionHandler(false)
        }))

        alert.addAction(UIAlertAction(title: "确认", style: .default, handler: { (_) in
            completionHandler(true)
        }))

        self.present(alert, animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: prompt, message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = defaultText
        }
        
        alert.addAction(UIAlertAction(title: "完成", style: .default, handler: { (_) in
            completionHandler(alert.textFields?.first?.text)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.canGoBack ? addCloseItem() : delCloseItem()
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        print("start")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("----------- something error")
        print(error.localizedDescription)
    }
    
    private func addCloseItem() {
        guard navigationItem.rightBarButtonItem == nil else { return }
        let item = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(clickCloseBtn))
        item.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], for: .normal)
        navigationItem.rightBarButtonItem = item
    }
    
    private func delCloseItem() {
        guard let _ = navigationItem.rightBarButtonItem else { return }
        navigationItem.rightBarButtonItem = nil
    }

    deinit {
        mWebView.removeObserver(self, forKeyPath: ob_progress)
        mWebView.removeObserver(self, forKeyPath: ob_title)
    }
}

extension HHWebBrowser {
    fileprivate func bindTitle(_ change: [NSKeyValueChangeKey : Any]?) {
        if !(titleString ?? "").isEmpty {
            title = titleString
        } else {
            if let aDic = change {
                title = aDic[NSKeyValueChangeKey(rawValue: "new")] as? String
            }
        }
    }
    
    fileprivate func updateProgress() {
//        print("progress: \(mWebView.estimatedProgress)")
        mProgress.isHidden = mWebView.estimatedProgress == 1
        mProgress.setProgress(Float((mWebView.estimatedProgress)), animated: true)
    }
}
