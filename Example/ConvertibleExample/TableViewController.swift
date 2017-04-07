import UIKit

class TableViewController: UITableViewController {

    private let dataSource = DataSource()
    
    private(set) var profile: Profile? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadProfile()
    }
    
    private func loadProfile() {
        dataSource.fetchProfile(withUsername: "tadija") { closure in
            do {
                let profile = try closure()
                self.profile = profile
            } catch {
                print(error)
            }
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile?.repos.count ?? 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath)
        if let repo = profile?.repos[indexPath.row] {
            cell.textLabel?.text = repo.name
        }
        return cell
    }
    
}
