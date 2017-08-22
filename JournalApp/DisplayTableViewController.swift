//
//  DisplayTableViewController.swift
//  JournalApp
//
//  Created by Dameon Green on 7/16/17.
//  Copyright © 2017 ApptasticVoyage. All rights reserved.
//

import UIKit

class DisplayTableViewController: UITableViewController, UISearchBarDelegate , UIViewControllerTransitioningDelegate{
    
    @IBOutlet weak var clearButton: UIButton!
    
    let transition = CircularTransition()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [Item] = []
    var selectedIndex: Int!
    var filteredData: [Item] = []

    var postShown = [Bool](repeating: false, count: 6)

    
    let newSwiftColor = UIColor(red: 255, green: 127, blue: 124)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        //change bar tint and size to 20
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 255, green: 127, blue: 124),
            NSFontAttributeName: UIFont(name: "Avenir", size: 20)!]
        
        //self.navigationController?.navigationBar.backgroundColor = UIColor.lightGray
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        createSearchBar()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createSearchBar() {
        
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search Easy Writer..."
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
        
        //customize searchabar
        // TextField Color Customization
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.textColor = UIColor.black
        
        // Placeholder Customization
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        
        textFieldInsideSearchBarLabel?.textColor = UIColor.lightGray
        
        // Clear Button Customization
        
        let clearButton = textFieldInsideSearchBar?.value(forKey: "clearButton") as! UIButton
        
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        clearButton.tintColor = UIColor.gray
        
        // Glass Icon Customization
        
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        
        glassIconView?.tintColor = UIColor.gray
        
    }
    func customizeSearchBar(){
        
        
    }
    

    func fetchData() {
        
        do {
            items = try context.fetch(Item.fetchRequest())
            filteredData = items
            print(items)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Couldn't Fetch Data")
        }
        
    }
    
    
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        let date = items.reversed()[indexPath.row].date
        let time = items.reversed()[indexPath.row].time
        
       //cell.textLabel?.text = items[indexPath.row].entry
       cell.textLabel?.text = filteredData.reversed()[indexPath.row].entry
        //cell.textLabel?.text = filteredData[indexPath.row].entry

        // maybe remove revesed
        if let date = date, let time = time {
            let timeStamp = "Added on \(date) at \(time)"
            cell.detailTextLabel?.text = timeStamp
            cell.contentView.alpha = 1

        }
        
        return cell
        
    }
    
//    func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
//        
//        UIView.animate(withDuration: 0.7, animations: {
//            cell.contentView.alpha = 0.08
//        })
//        
//    }
//    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // Determine if the post is displayed. If yes, we just return and no animation will be created
//        if postShown[indexPath.row] {
//            return
//        }
//        
        // Indicate the post has been displayed, so the animation won't be displayed again
   //     postShown[indexPath.row] = true
        //use fade in this time
        // Define the initial state (Before the animation)
        cell.alpha = 0
        
        // Define the final state (After the animation)
        UIView.animate(withDuration: 0.25, animations: { cell.alpha = 1 })
        
         // Define the initial state (Before the animation)
         let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 500, 60, 0)
         cell.layer.transform = rotationTransform
         
         // Define the final state (After the animation)
         UIView.animate(withDuration: 0.25, animations: { cell.layer.transform = CATransform3DIdentity })
 
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            let item = self.filteredData.reversed()[indexPath.row]
            self.context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            self.filteredData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
        let share = UITableViewRowAction(style: .default, title: "Share") { (action, indexPath) in
            // share item at indexPath
            print("Share")
            
        }
        // change the delete and share colors
        delete.backgroundColor = UIColor(red: 0/255, green: 177/255, blue: 106/255, alpha: 1.0)
        share.backgroundColor = UIColor(red: 54/255, green: 215/255, blue: 183/255, alpha: 1.0)
        
        return [delete,share]
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        
        // this deselects the row after tapping
        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "UpdateVC", sender: self)
//        let detail = self.storyboard?.instantiateViewController(withIdentifier: "UpdateVC") as! UpdateViewController
//        self.navigationController?.pushViewController(detail, animated: true)
//        detail.item = self.items[indexPath.row]
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredData = items
            
        } else {
            // filter the array here, then update table
             filteredData = items.filter { ($0.entry?.lowercased().contains(searchText.lowercased()))! }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
    }
    
    
}
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = clearButton.center
        transition.circleColor = clearButton.backgroundColor!
        
        return transition
        
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = clearButton.center
        transition.circleColor = clearButton.backgroundColor!
        
        return transition
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpdateVC" {
            // Set item here
            let updateVC = segue.destination as! UpdateViewController
            updateVC.item = items.reversed()[selectedIndex!]
            
            updateVC.transitioningDelegate = self
            updateVC.modalPresentationStyle = .custom
            
        } else if segue.identifier == "NewEntry"{
            let addVC = segue.destination as! AddItemViewController
            
            addVC.transitioningDelegate = self
            addVC.modalPresentationStyle = .custom
            
        }
        
    }



}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
