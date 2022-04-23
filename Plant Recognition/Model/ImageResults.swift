//
//  ImageResults.swift
//  Plant Recognition
//
//  Created by Mohammad Hamudeh on 23/04/2022.
//

import Foundation
// I will use here the simplest way for decoding
struct ImageResults:Codable{
   
    var results:[dataResults]
}
struct dataResults:Codable{
    var score:Double
    var species:Species
}
struct Species:Codable{
    var scientificNameWithoutAuthor,scientificNameAuthorship,scientificName:String
}
