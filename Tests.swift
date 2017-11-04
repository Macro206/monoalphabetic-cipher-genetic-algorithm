//
//  Tests.swift
//  GeneticAlgorithmSwift
//
//  Created by Matteo G. Pozzi on 27/10/2017.
//  Copyright © 2017 Matteo G. Pozzi. All rights reserved.
//

import Foundation

func randomlyEncrypt(text sourceText: String) -> String {
    let formattedText = String(sourceText.lowercased().characters.filter { "abcdefghijklmnopqrstuvwxyz".characters.contains($0) })
    
    print(formattedText)
    print()
    
    let key = MonoAlphabeticCipherKey()
    key.shuffleKey()
    
    key.generateText(textString: formattedText)
    return key.generatedText
}
