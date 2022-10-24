//
//  TableViewController.swift
//  AssignmentOne
//
//  Created by Muhammad Ashraf on 9/15/22.
//
import UIKit

var metStepGoal = false

class TableViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    var flip_flop = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if metStepGoal {
            return 2
        }
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StepTrackerCell", for: indexPath)
            
            cell.textLabel?.text = "Step Tracker"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath)
            
            cell.textLabel?.text = "Game (Unlocked and Ready!)"
            
            return cell
            
        }
    }
}
