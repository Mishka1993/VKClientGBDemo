//
//  VKAdapter.swift
//  homeWork_1
//
//  Created by Михаил Киржнер on 25.03.2022.
//  Copyright © 2022 Марат Нургалиев. All rights reserved.
//

import Foundation
import RealmSwift

final class VKAdapter {
    private let weatherService = AlamofireService()
    private var realmNotificationTokens: [String: NotificationToken] = [:]
    func getWeathers(inCity user: String, then completion: @escaping ([VKFriend]) -> Void) {
        guard let realm = try? Realm()
                , let realmUser = realm.object(ofType: VkFriend.self, forPrimaryKey: user) else {return}
        self.realmNotificationTokens[user]?.stop()
        let token = realmUser.weathers.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            case .update(let realmWeathers, _, _, _):
                var weathers: [Weather] = []
                for realmWeather in realmWeathers {
                    weathers.append(self.weather(from: realmWeather)) }
                self.realmNotificationTokens[city]?.stop()
                completion(weathers)
            case .error(let error):
                fatalError("\(error)")
            case .initial:
                break
            }
        }
        self.realmNotificationTokens[city] = token
        weatherService.loadWeatherData(city: city)
    }
    private func weather(from rlmWeather: VkFriend) -> VKFriend {
        return Weather(cityName: rlmWeather.city,
                       date: Date(timeIntervalSince1970: rlmWeather.date),
                       temperature: rlmWeather.temp,
                       pressure: rlmWeather.pressure,
                       humidity: Double(rlmWeather.humidity),
                       weatherName: rlmWeather.weatherName, weatherIconName: rlmWeather.weatherIcon, windSpeed: rlmWeather.windSpeed,
                       windDegrees: rlmWeather.windDegrees)
        
    }
}

