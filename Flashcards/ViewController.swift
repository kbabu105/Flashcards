//
//  ViewController.swift
//  Flashcards
//
//  Created by Krishna on 10/13/18.
//  Copyright © 2018 Krishna. All rights reserved.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    //array to hold flashcards
    var flashcards = [Flashcard]()
    
    //current flashcard index
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //curves the edges
        card.clipsToBounds = true
        card.layer.cornerRadius = 50.0
        
        //read saved flashcards
        readSavedFlashcards()
        
        
        //store flashcard on start if no UserDefault
        if(flashcards.count == 0){
            updateFlashcard(question: "Who is the first computer programmer?", answer: "Ada Lovelace")
        }
        else{ //for the saved flashcards
            updateLabels()
            updateNextPrevButtons()
        }
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
        let flashcard = Flashcard(question: question, answer: answer)
        flashcards.append(flashcard)
        
        print("Added new flashcard")
        print("Currently \(flashcards.count) flashcards")
        
        //current index update
        currentIndex = flashcards.count - 1
        print("Current index is \(currentIndex)")
    
        //update buttons so they can act correctly upon button press
        updateNextPrevButtons()
        
        //update labels
        updateLabels()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
    }
    
    @IBAction func didTapOnNext(_ sender: UIButton) {
        //inc index before label update call on 'current index's flashcard'
        currentIndex = currentIndex + 1
        
        //update labels
        updateLabels()
        
        //update buttons
        updateNextPrevButtons()
    }
    
    @IBAction func didTapOnPrev(_ sender: UIButton) {
        currentIndex = currentIndex - 1
        
        updateLabels()
        
        updateNextPrevButtons()
        
    }
    
    func updateNextPrevButtons() {
        //if looking at last flashcard: disable Next button
        if(currentIndex == flashcards.count-1)
        {
            nextButton.isEnabled = false
        } else{ //else: keep Next enabled
            nextButton.isEnabled = true
        }
        //if looking at first flashcard: disable Prev button
        if(currentIndex == 0)
        {
            prevButton.isEnabled = false
        } else{ //else: keep Prev enabled
            prevButton.isEnabled = true
        }
    }
    
    func updateLabels() {
        //get cur flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        //update labels
        backLabel.text = currentFlashcard.answer
        frontLabel.text = currentFlashcard.question
    }
    
    func saveAllFlashcardsToDisk(){
        //UserDefaults does know how to store an array of dictionaries, so we're going to need to convert our array of Flashcard to dictionaries first
        let dictionaryArray = flashcards.map { (card) -> [String:String] in
            return ["question": card.question, "answer": card.answer]
        }
        
        //save array on disk using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        print("Flashcards saved to UserDefaults")
        
    }
    
    func readSavedFlashcards(){
        //read dictionaryArray from disk (if any)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String:String]] { //dictionaryArray variable set only if something exists on disk
            //in here we know we def have a dictionaryArray
            
            //convert array of dictionaries -> array of flashcards
            let savedCards = dictionaryArray.map{ dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            
            //put all cards in flashcards array
            flashcards.append(contentsOf: savedCards)
            
        }
        
    }
}

