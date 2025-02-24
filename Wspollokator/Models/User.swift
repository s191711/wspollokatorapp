//
//  User.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 30/10/2021.
//

import CoreLocation
import SwiftUI

class User: Hashable, Identifiable {
    let id: String
    
    var avatarImage: Image?
    var name: String
    var surname: String
    var email: String!
    var pointOfInterest: CLLocationCoordinate2D?
    var targetDistance: Double
    var preferences: [FilterOption: FilterAttitude]
    var description: String
    var savedUsers: [User]
    var ratings: [Rating]?
    var isSearchable: Bool
    
    var averageScore: Int {
        guard ratings!.count > 0 else { return 0 }
        return Int(round(Double(ratings!.map({ $0.score }).reduce(0, +)) / Double(ratings!.count)))
    }
    
    init(id: String, avatarImage: Image? = nil, name: String, surname: String, email: String? = nil, pointOfInterest: CLLocationCoordinate2D? = nil, targetDistance: Double = ViewModel.defaultTargetDistance, preferences: [FilterOption: FilterAttitude] = ViewModel.defaultPreferences, description: String = "", savedUsers: [User] = [User](), ratings: [Rating]? = nil, isSearchable: Bool = false) {
        self.id = id
        self.avatarImage = avatarImage
        self.name = name
        self.surname = surname
        self.email = email
        self.pointOfInterest = pointOfInterest
        self.targetDistance = targetDistance
        self.preferences = preferences
        self.description = description
        self.savedUsers = savedUsers
        self.ratings = ratings
        self.isSearchable = isSearchable
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    /// A predicate for sorting users by surname, name, and ID in an ascending order.
    static func sortingPredicate(user1: User, user2: User) -> Bool {
        if user1.surname != user2.surname {
            return user1.surname < user2.surname
        } else if user1.name != user2.name {
            return user1.name < user2.name
        } else {
            return user1.id < user2.id
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// Calculates distance, in kilometers, between the receiver's and other `user`'s `pointOfInterest`.
    func distance(from user: User) -> Double? {
        guard pointOfInterest != nil && user.pointOfInterest != nil else { return nil }
        
        let receiverPointLocation = CLLocation(latitude: pointOfInterest!.latitude, longitude: pointOfInterest!.longitude)
        let otherUserPointLocation = CLLocation(latitude: user.pointOfInterest!.latitude, longitude: user.pointOfInterest!.longitude)
        
        return receiverPointLocation.distance(from: otherUserPointLocation) / 1000
    }
    
    /// Returns a string describing the minimum and maximum distance between the receiver's `pointOfInterest` and other `user`'s area of interest.
    func distanceRange(for user: User) -> String? {
        guard let distance = distance(from: user) else { return nil }
        
        let lowerBound = Float(max(0, distance - user.targetDistance))
        let upperBound = Float(distance + user.targetDistance)
        
        if lowerBound == upperBound {
            return String.localizedStringWithFormat("%.1f km", 0)
        } else if lowerBound == 0 {
            return String.localizedStringWithFormat("≤ %.1f km", upperBound)
        } else {
            return String.localizedStringWithFormat("%.1f‐%.1f km", lowerBound, upperBound)
        }
    }
    
    /// Decodes street or city describing location of the receiver's `pointOfInterest`.
    func fetchNearestLocationName() async -> String? {
        guard pointOfInterest != nil else { return nil }
        
        let location = CLLocation(latitude: pointOfInterest!.latitude, longitude: pointOfInterest!.longitude)
        let geocoder = CLGeocoder()
        
        if let placemark = try? await geocoder.reverseGeocodeLocation(location).first {
            return placemark.name ?? placemark.locality
        } else {
            return nil
        }
    }
}
