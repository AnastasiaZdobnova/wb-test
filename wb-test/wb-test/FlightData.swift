//
//  FlightData.swift
//  wb-test
//
//  Created by Анастасия Здобнова on 25.09.2023.
//

import Foundation

struct Seat: Codable {
    let count: Int
    let passengerType: String
}

struct Flight: Codable {
    let endCity: String
    let endDate: String
    let endLocationCode: String
    let price: Int
    let searchToken: String
    let seats: [Seat]
    let serviceClass: String
    let startCity: String
    let startDate: String
    let startLocationCode: String
    //var isLiked = false
}

struct FlightResponse: Codable {
    let flights: [Flight]
}

