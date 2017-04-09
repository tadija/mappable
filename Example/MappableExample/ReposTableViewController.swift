import UIKit

class ReposTableViewController: UITableViewController {
    
    private let dataSource = DataSource()
    
    private(set) var profile: Profile? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshData()
        
        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
            refreshControl.beginRefreshing()
            tableView.setContentOffset(CGPoint(x: 0, y: -refreshControl.bounds.height * 2), animated: animated)
        }
    }
    
    func refreshData() {
        dataSource.fetchProfile(username: "tadija") { closure in
            do {
                let profile = try closure()
                self.profile = profile
            } catch {
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile?.repos.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath)
        if let repo = profile?.repos[indexPath.row] {
            cell.textLabel?.text = repo.name
        }
        return cell
    }
    
}
