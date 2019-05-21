//
//  ViewController.swift
//  autocomplete_testing
//
//  Created by Antonie Jovanoski on 3/13/19.
//  Copyright © 2019 Antonie Jovanoski. All rights reserved.
//

import UIKit

enum KeywordState {
    case entering, other
}

extension String {
    func isAlphaNumeric() -> Bool {
        return rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
    }
}

class ViewController: UIViewController, UITextViewDelegate {
    
    var keywordBuffer: String = String()
    var suggestionKeyWordState: KeywordState = .other

    @IBOutlet weak var textView: UITextView!
    
    let inputAssistantView: InputAssistantView = InputAssistantView()
    let allSuggestions = ["Suggestion", "Test", "Hello", "World", "More", "Suggestions"]
    var matchedSuggestions: [String] = []
    let fixedSuggestion: [String] = ["[ ]", "{ }"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        inputAssistantView.delegate = self
        inputAssistantView.dataSource = self
        inputAssistantView.attach(to: textView)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("range \(range)")
        print("replacement text \(text)")
        
        if range.length == 1 { //delete
            //remove character from keyword buffer
            
            if !keywordBuffer.isEmpty {
                keywordBuffer.removeLast()
            }
        } else {
        
            if text.isAlphaNumeric() {
                suggestionKeyWordState = .entering
                keywordBuffer.append(text)
                
            } else {
                suggestionKeyWordState = .other
                keywordBuffer = String()
            }
        }
        
        matchedSuggestions = allSuggestions.filter { $0.hasPrefix(keywordBuffer) }
        matchedSuggestions.append(contentsOf: fixedSuggestion)
        
        inputAssistantView.reloadData()
        
        return true
    }
}

extension ViewController: InputAssistantViewDataSource {
    func textForEmptySuggestionsInInputAssistantView() -> String? {
        return nil
    }
    
    func numberOfSuggestionsInInputAssistantView() -> Int {
        return matchedSuggestions.count
    }
    
    func inputAssistantView(_ inputAssistantView: InputAssistantView, nameForSuggestionAtIndex index: Int) -> String {
        return matchedSuggestions[index]
    }
}

extension ViewController: InputAssistantViewDelegate {
    func inputAssistantView(_ inputAssistantView: InputAssistantView, didSelectSuggestionAtIndex index: Int) {

        
//        if let selectedRange = self.textView.selectedTextRange {
//            if let newPosition = self.textView.position(from: selectedRange.start, offset: -keywordBuffer.count) {
//
//                // set the new position
//                self.textView.selectedTextRange = self.textView.textRange(from: newPosition, to: newPosition)
//            }
//        }
        if index < (matchedSuggestions.endIndex - fixedSuggestion.count) {
        
            let lengthOfMatched = matchedSuggestions[index].count
            let textToInsert = matchedSuggestions[index].suffix(lengthOfMatched - keywordBuffer.count)
            
            self.textView.insertText(String(textToInsert))
        } else {
            self.textView.insertText(matchedSuggestions[index])
        }
    }
}

