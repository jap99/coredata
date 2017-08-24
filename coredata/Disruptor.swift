//
//  Disruptor.swift
//  coredata
//
//  Created by Javid Poornasir on 8/22/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import Foundation

class DisruptorDetails {
    var number: Int?
    var bed: String?
    var bath: String?
    var buyerCities: [String]?
    var city: String? /////////////
    var firstName: String? ////////////
    var priceMax: Int? //////////////////////
    var priceMin: Int?
    var leadCreationDate: Date?
    var leadType: String? // buyer or seller
    var leadAcceptanceDate: Date?
    var matchID: Int?
    var email: String?
    var mortStatus: String?
    var reason: String?
    var timeFrame: String?
    var type: String?
}

// ORDER FOR BUYER - optional for buyers: buyerCities array, mortStatus, bed, bath

// number
// email
// city
// leadCreationDate
// leadAcceptanceDate
// mortStatus
// bed
// bath
// buyerCities
// timeFrame
// matchID

// ORDER FOR SELLER - optional for sellers: reason, priceMin, timeFrame

// number
// email
// leadCreationDate
// leadAcceptanceDate
// mortStatus
// bed
// bath
// buyerCities
// reason
// priceMin
// timeFrame
// matchID






//init {
//    
//}


//[ ["bed" : "5", "bath":"2", ...] ]


// Step 1: Find out if leadType is a seller or a buyer
// Step 2: If it's a seller, then don't show the reason, priceMin, or timeFrame
// ...
