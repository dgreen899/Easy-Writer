//
//  AddItemViewController.swift
//  JournalApp
//
//  Created by Dameon Green on 7/15/17.
//  Copyright © 2017 ApptasticVoyage. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var itemEntryTextView: UITextView?
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveItem(_ sender: Any) {
        
        guard let enteredText = itemEntryTextView?.text else {
            return
        }
        
        if enteredText.isEmpty ||  itemEntryTextView?.text == "Type anything..."{
            
            let alert = UIAlertController(title: "Please Type Something", message: "Your entry was left blank.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default) { action in
                
            })
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/YY"
            let currentDate = formatter.string(from: date)
            
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            let currentTime = timeFormatter.string(from: date)
            
            guard let entryText = itemEntryTextView?.text else {
                return
            }
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newEntry = Item(context: context)
            newEntry.entry = entryText
            newEntry.date = currentDate
            newEntry.time = currentTime
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            dismiss(animated: true, completion: nil)
            
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemEntryTextView?.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.black
    }


    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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
