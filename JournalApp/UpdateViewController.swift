//
//  UpdateViewController.swift
//  JournalApp
//
//  Created by Dameon Green on 7/16/17.
//  Copyright © 2017 ApptasticVoyage. All rights reserved.
//

import UIKit

class UpdateViewController: UIViewController, UITextViewDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var entryText: UITextView!
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


     var item: Item!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        entryText!.delegate = self
        entryText!.becomeFirstResponder()
        configureEntryData(entry: item)

        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func updateAction(_ sender: Any) {
        guard let newEntry = entryText.text else  {
            return
        }
        
        item.entry = newEntry
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureEntryData(entry: Item) {
        entryText!.text = entry.entry ?? "Nothing to update."
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
