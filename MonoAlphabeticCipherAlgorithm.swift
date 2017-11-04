//
//  MonoAlphabeticCipherAlgorithm.swift
//  GeneticAlgorithmSwift
//
//  Created by Matteo Pozzi on 02/03/2015.
//  Copyright (c) 2015 Matteo G. Pozzi. All rights reserved.
//

import Cocoa

var magicLetter: Int = 0

class MonoAlphabeticCipherAlgorithm: NSObject {
    
    var bigrams: NSMutableDictionary = NSMutableDictionary()
    
    // Import the bigrams
    func importBigrams() {
        let fileString = try! NSString(contentsOfFile: bigramsLocation, usedEncoding: nil)
        
        let bigramStrings = fileString.components(separatedBy: "\n");
        
        var totalFrequency: Int = 0
        
        for string in bigramStrings {
            let frequency: Int = Int(((string as NSString).substring(from: 3) as NSString).intValue)
            
            totalFrequency += frequency
        }
        
        for string in bigramStrings {
            let key: String = (string as NSString).substring(to: 2)
            let frequencyProportion: Double = Double(((string as NSString).substring(from: 3) as NSString).intValue) / Double(totalFrequency)
            
            bigrams.setObject(Double(frequencyProportion), forKey: (key as NSString))
        }
    }
    
    func run(sourceText: String) {
        
        let populationSize = 50
        
        // Setup bigrams
        importBigrams()
        
        // Find 'e'
        var maxFrequency: Int = 0
        var letterFrequencies: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        for c in 0..<sourceText.characters.count {
            let letter = Int(Int((sourceText as NSString).character(at: c)) - 97)
            letterFrequencies[letter] += 1
        }
        for i in 0..<26 {
            if letterFrequencies[i] > maxFrequency {
                maxFrequency = letterFrequencies[i]
                magicLetter = i
            }
        }
        
        // Setup initial generation
        var population: [MonoAlphabeticCipherKey] = []
        
        for _ in 0..<populationSize {
            let newKey = MonoAlphabeticCipherKey()
            newKey.shuffleKey()
            population.append(newKey)
        }
        
        // Main loop for algorithm
        while (true) {
            
            // Calculate each key's bigram proportions and fitness (if they haven't been calculated before)
            for key in population {
                if key.isConfigured == false {
                    key.generateText(textString: sourceText)
                    key.calculateBigramProportions(bigrams: bigrams)
                    key.isConfigured = true
                }
            }
            
            // Sort the population by fitness and print out the best key's generated text, fitness and the key itself
            population.sort(by: { $0.fitness > $1.fitness })
            print(population[0].generatedText)
            print(population[0].fitness)
            print(population[0].keyString)
            print("")
            
            // Create a new population
            let numberToKeep: Int = Int(floor(Double(populationSize)/Double(4)))
            var newPopulation: [MonoAlphabeticCipherKey] = []
            
            // Perform several passes over the keys to be kept
            for n in 0..<4 {
                for i in 0..<numberToKeep {
                    // If this is the first pass, keep the keys as they are
                    // Otherwise mutate them before adding them to the new population
                    if (n == 0) {
                        newPopulation.append(population[i])
                    }
                    else {
                        let newKey = population[i].mutate()
                        newPopulation.append(newKey)
                    }
                }
            }
            
            // Create random keys to fill the rest of the new population
            for _ in 0..<(populationSize - newPopulation.count) {
                let newKey = MonoAlphabeticCipherKey()
                newKey.shuffleKey()
                newPopulation.append(newKey)
            }
            
            let buffer = newPopulation.last
            newPopulation.removeLast()
            newPopulation.insert(buffer!, at: 0)
            
            population = newPopulation
        }
        
    }
}

class MonoAlphabeticCipherKey: NSObject {
    
    var keyString: String  = "abcdefghijklmnopqrstuvwxyz"
    var alphabet: NSString = "abcdefghijklmnopqrstuvwxyz"
    var generatedText: String = ""
    var bigramFrequencies: NSMutableDictionary = NSMutableDictionary()
    var fitness: Double = 0
    var letterDifferences: NSMutableDictionary = NSMutableDictionary()
    var isConfigured: Bool = false
    
    // Places the letter "e" into the key at the index of the letter with highest frequency in the text
    // This ensures that the key will always map that letter to "e"
    // The letter previously at that index is swapped accordingly
    func regulateMagicLetter() {
        if (keyString as NSString).range(of: "e").location == magicLetter {
            return
        }
        
        let substitutionRange = (keyString as NSString).range(of: "e")
        
        let newKeyString: NSMutableString = (keyString as NSString).mutableCopy() as! NSMutableString
        newKeyString.replaceCharacters(in: NSMakeRange(substitutionRange.location, substitutionRange.length), with: (keyString as NSString).substring(with: NSMakeRange(magicLetter, 1)))
        newKeyString.replaceCharacters(in: NSMakeRange(magicLetter, 1), with: "e")
        
        keyString = (newKeyString.copy()) as! String
    }
    
    // Shuffles the letters of the key
    func shuffleKey() {
        keyString = keyString.jumble
        self.regulateMagicLetter()
    }
    
    // Generates output text by applying the key's substitution to the input
    func generateText(textString: String) {
        var buffer: String = ""
        
        for i in 0..<(textString as NSString).length {
            for c in 0..<26 {
                if (textString as NSString).character(at: i) == alphabet.character(at: c) {
                    buffer = buffer + "\(Character(UnicodeScalar((keyString as NSString).character(at: c))!))"
                }
            }
            
        }
        
        generatedText = buffer.copy() as! String
    }
    
    // Calculates the bigram frequencies in the generated output text
    func calculateBigramFrequencies() {
        populateBigramDictionary()
        
        for i in 0..<(generatedText.characters.count - 1) {
            let bigram = (generatedText as NSString).substring(with: NSMakeRange(i, 2))
            
            let totalFrequency: Int = (bigramFrequencies.object(forKey: bigram) as! Int) + 1
            
            bigramFrequencies.setObject(totalFrequency, forKey: bigram as NSCopying)
        }
        
    }
    
    // Calculates the bigram proportions in the generated output text
    func calculateBigramProportions(bigrams: NSMutableDictionary) {
        calculateBigramFrequencies()
        
        for (bigram, value) in bigramFrequencies {
            let currentProportion: Double = Double(truncating: value as! NSNumber) / Double((generatedText as NSString).length - 1)
            let actualProportion: Double  = (bigrams.object(forKey: (bigram as! String).uppercased()) as! Double)
            
            var delta = actualProportion - currentProportion
            if delta < 0 {delta *= -1}
            
            fitness -= delta
            
            bigramFrequencies.setObject(NSNumber(value: currentProportion), forKey: (bigram as! NSString))
        }
    }
    
    // Swaps two random letters in the key
    func mutate() -> MonoAlphabeticCipherKey {
        let child: MonoAlphabeticCipherKey = MonoAlphabeticCipherKey()
        
        let newKeyString: NSMutableString = ((self.keyString as NSString).mutableCopy() as! NSMutableString)
        
        // TODO: Test for potential performance gains by varying number of times the following code executes
        for _ in 0..<1 {
            let randomIndex1: Int = Int(arc4random_uniform(26))
            let randomIndex2: Int = Int(arc4random_uniform(26))
            let charBuffer = (self.keyString as NSString).substring(with: NSMakeRange(randomIndex1, 1))
            
            newKeyString.replaceCharacters(in: NSMakeRange(randomIndex1, 1), with: (self.keyString as NSString).substring(with: NSMakeRange(randomIndex2, 1)))
            newKeyString.replaceCharacters(in: NSMakeRange(randomIndex2, 1), with: charBuffer)
        }
        
        child.keyString = newKeyString as String
        
        child.regulateMagicLetter()
        
        return child
    }
    
    // Populates the bigram dictionary with zeroes for each bigram
    func populateBigramDictionary() {
        for x in 0..<26 {
            for y in 0..<26 {
                let charX = 97 + x // 'a' = 97
                let charY = 97 + y
                let bigram = NSString(format: "%c%c", charX, charY)
                bigramFrequencies.setObject(Int(0), forKey: bigram)
            }
        }
    }
    
    // Populates the letter difference dictionary with zeroes for each letter
    func populateLetterDifferenceDictionary() {
        for c in 0..<26 {
            let charX = 97 + c
            letterDifferences.setObject(Int(0), forKey: NSString(format: "%c", charX))
        }
    }
    
}

// Extensions to add various methods
extension Array {
    var shuffle:[Element] {
        var elements = self
        for index in 0..<elements.count {
            let newIndex = Int(arc4random_uniform(UInt32(elements.count-index)))+index
            if index != newIndex { // Check if you are not trying to swap an element with itself
                elements.swapAt(index, newIndex)
            }
        }
        return elements
    }
    var chooseOne: Element {
        return self[Int(arc4random_uniform(UInt32(count)))]
    }
    
}
extension String {
    var jumble:String {
        return String(Array(self.characters).shuffle)
    }
}
