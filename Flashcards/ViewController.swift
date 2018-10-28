//
//  ViewController.swift
//  Flashcards
//
//  Created by Krishna on 10/13/18.
//  Copyright © 2018 Krishna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        card.clipsToBounds = true
        card.layer.cornerRadius = 50.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        if(frontLabel.isHidden){
            frontLabel.isHidden = false
        }
        else{
            frontLabel.isHidden = true
        }
    }
    //not putting on inner 'View' means you'd have to click on white part for question to change to answer
    
    func updateFlashcard(question: String, answer: String){
        frontLabel.text! = question;
        backLabel.text! = answer;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
        
        
    }
}

