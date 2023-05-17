//
//  BaseViewController.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 12.05.2023.
//

import UIKit

class BaseViewController: UIViewController {
    
    var automaticallyAdjustsLeftBarButtonItem = true
    
    //MARK: - Initializing
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    //MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        makeUI()
        setNavigationBarStyle()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.automaticallyAdjustsLeftBarButtonItem {
            self.adjustNavigationBarButtonItems()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    // MARK: Adjusting Navigation Item
    
    func adjustNavigationBarButtonItems(forced: Bool = false) {
        if let count = navigationController?.viewControllers.count, count <= 1, !forced {
            navigationItem.leftBarButtonItem = nil
        } else { // pushed, presented
            navigationItem.leftBarButtonItem = configure(UIBarButtonItem()) {
                $0.image = UIImage(named: "isBack")
                $0.title = ""
                $0.tintColor = .systemBlue
                $0.target = self
                $0.action = #selector(backAction)
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func backAction() {
        if let navigationController = self.navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: Layout Constraints
    
    func makeUI() {
        updateUI()
    }
    
    func updateUI() {
        
    }
    
    @objc func didBecomeActive() {
        self.updateUI()
    }
    
    @objc func willResignActive() {
        
    }
    
    // MARK: Navigation Bar
    
    /// Setting the default UINavigationBar style
    func setNavigationBarStyle() {

    }
    
    // MARK: Init
    
    @available(*, unavailable, message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @available(*, unavailable, message: "Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view controller from a nib is unsupported in favor of initializer dependency injection.")
    }
}
