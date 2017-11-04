//
//  main.swift
//  GeneticAlgorithmSwift
//
//  Created by Matteo Pozzi on 02/03/2015.
//  Copyright (c) 2015 Matteo G. Pozzi. All rights reserved.
//

import Foundation

// TODO: Replace this with a path to your bigrams file
let bigramsLocation = "/Users/Matteo/Desktop/english_bigrams.txt"

// Uncomment the following two lines and replace "originalString" with the text you wish to experiment with
//let originalString = ""
//let inputString = randomlyEncrypt(text: originalString)

// This is the original encrypted string from the challenge
// As a guide, the text should begin with "In the same hour" (although it will all be lower case and without spaces)
let inputString = "btjpxrmlxpcuvamlxicvjpibtwxvrcimlmtrpmtnmtnyvcjxcdxvmwmbtrjjpxamtngxrjbahuqctjpxqgmrjxvcijpxymggcijpxhbtwrqmgmaxmtnjpxhbtwrmyjpxqmvjcijpxpmtnjpmjyvcjxjpxtjpxhbtwracutjxtmtaxymrapmtwxnmtnpbrjpcuwpjrjvcufgxnpblrcjpmjjpxscbtjrcipbrgcbtryxvxgccrxnmtnpbrhtxxrrlcjxctxmwmbtrjmtcjpxvjpxhbtwavbxnmgcunjcfvbtwbtjpxmrjvcgcwxvrjpxapmgnxmtrmtnjpxrccjprmexvrmtnjpxhbtwrqmhxmtnrmbnjcjpxybrxlxtcifmfegctypcrcxdxvrpmggvxmnjpbryvbjbtwmtnrpcylxjpxbtjxvqvxjmjbctjpxvxcirpmggfxagcjpxnybjpram"

let algorithm = MonoAlphabeticCipherAlgorithm()

algorithm.run(sourceText: inputString)
