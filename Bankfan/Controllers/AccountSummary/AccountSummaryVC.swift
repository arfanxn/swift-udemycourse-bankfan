//
//  AccountSummaryVC.swift
//  Bankfan
//
//  Created by Muhammad Arfan on 01/01/23.
//

import UIKit

class AccountSummaryVC: UIViewController {
    
    // Data
    private var accounts = [AccountSummaryTableViewCell.ViewModel]()
    private var isAccountsLoaded = false
    
    // View
    var tableView = UITableView()
    lazy var logoutBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logoutBtnTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Methods
extension AccountSummaryVC {
    
    private func setup() {
        setupNavigationBar()
        setupTableView()
        setupTableHeaderView()
        setupRefreshControl()
        // fetchData() /// Disabled for testing the skeleton loader
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }
    
    private func setupRefreshControl () {
        self.refreshControl.tintColor = .Asset.primary
        self.refreshControl.addTarget(self,
                                      action: #selector(self.refreshContent),
                                      for: .primaryActionTriggered)
        tableView.refreshControl = refreshControl
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .Asset.primary
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.register(
            AccountSummaryTableViewCell.self, forCellReuseIdentifier: AccountSummaryTableViewCell.identifier
        )
        tableView.register(
            AccountSummarySkeletonTableViewCell.self, forCellReuseIdentifier: AccountSummarySkeletonTableViewCell.identifier
        )
        tableView.rowHeight = AccountSummaryTableViewCell.rowHeight
        tableView.tableFooterView = UIView()
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableHeaderView() {
        let header = AccountSummaryHeaderView(frame: .zero)
        
        var size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        header.frame.size = size
        
        tableView.tableHeaderView = header
    }
    
    private func fetchData() {
        self.isAccountsLoaded = false
        
        let accounts = [
            AccountSummaryTableViewCell.ViewModel(accountType: .Banking,
                                                  accountName: "Basic Savings",
                                                  balance: 929466.23),
            AccountSummaryTableViewCell.ViewModel(accountType: .Banking,
                                                  accountName: "No-Fee All-In Chequing",
                                                  balance: 17562.44),
            AccountSummaryTableViewCell.ViewModel(accountType: .CreditCard,
                                                  accountName: "Visa Avion Card",
                                                  balance: 412.83),
            AccountSummaryTableViewCell.ViewModel(accountType: .CreditCard,
                                                  accountName: "Student Mastercard",
                                                  balance: 50.83),
            AccountSummaryTableViewCell.ViewModel(accountType: .Investment,
                                                  accountName: "Tax-Free Saver",
                                                  balance: 2000.00),
            AccountSummaryTableViewCell.ViewModel(accountType: .Investment,
                                                  accountName: "Growth Fund",
                                                  balance: 15000.00),
        ]
        
        self.accounts = accounts
        self.isAccountsLoaded = true
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
    }
}

// MARK: - Event Listener
extension AccountSummaryVC {
    @objc private func logoutBtnTapped (_ sender : UIButton) {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    @objc private func refreshContent () {
        fetchData()
    }
}

// MARK: - Table View Data Source
extension AccountSummaryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch true {
        case self.isAccountsLoaded && !self.accounts.isEmpty:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: AccountSummaryTableViewCell.identifier, for: indexPath)
                as! AccountSummaryTableViewCell
            cell.configure(with: self.accounts[indexPath.row])
            return cell
        default:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: AccountSummarySkeletonTableViewCell.identifier, for: indexPath)
                as! AccountSummarySkeletonTableViewCell
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isAccountsLoaded ? self.accounts.count : 10
    }
}

// MARK: - Table View Delegate
extension AccountSummaryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - Networking Layer
extension AccountSummaryViewController {
    
    /* /// Disabled for future usage
     func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile,NetworkError>) -> Void) {
         let url = URL(string: "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userId)")!

         URLSession.shared.dataTask(with: url) { data, response, error in
             guard let data = data, error == nil else {
                 completion(.failure(.serverError))
                 return
             }
             
             do {
                 let profile = try JSONDecoder().decode(Profile.self, from: data)
                 completion(.success(profile))
             } catch {
                 completion(.failure(.decodingError))
             }
         }.resume()
     }
     */
    
}
