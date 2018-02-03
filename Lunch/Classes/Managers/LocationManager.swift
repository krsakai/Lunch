//
//  LocationManager.swift
//  Lunch
//
//  Created by 酒井邦也 on 2018/01/21.
//  Copyright © 2018年 酒井邦也. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftTask

internal final class LocationManager: NSObject  {
    
    static let shared = LocationManager()
    fileprivate var locationManager: CLLocationManager?
    
    fileprivate var fulfill: ((CLLocation) -> Void)?
    fileprivate var reject: ((LunchError) -> Void)?
    
    func setup() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func reset() {
        fulfill = nil
        reject = nil
    }
    
    typealias CurrentLocationTask = Task<Void, CLLocation, LunchError>
    func currentLocationTask(isForceReload: Bool = false, isForceCurrent: Bool = false) -> CurrentLocationTask {
        AppDelegate.sideMenu?.startLocationRequest()
        return CurrentLocationTask { _, fulfill, reject, _ in
            guard !isForceReload else {
                self.fulfill = fulfill
                self.reject = reject
                self.locationManager?.requestLocation()
                return
            }
            
            guard !isForceCurrent else {
                if let location = DeviceModel.currentLocation, !DeviceModel.searchLocationDateTime.isExpied() {
                    AppDelegate.sideMenu?.stopLocationRequest()
                    fulfill(location)
                } else {
                    self.fulfill = fulfill
                    self.reject = reject
                    self.locationManager?.requestLocation()
                }
                return
            }
            
            if let customLocation = DeviceModel.customLocation {
                AppDelegate.sideMenu?.stopLocationRequest()
                let location = CLLocation(latitude: customLocation.latitude, longitude: customLocation.longitude)
                fulfill(location)
            } else {
                if let location = DeviceModel.currentLocation, !DeviceModel.searchLocationDateTime.isExpied() {
                    AppDelegate.sideMenu?.stopLocationRequest()
                    fulfill(location)
                } else {
                    self.fulfill = fulfill
                    self.reject = reject
                    self.locationManager?.requestLocation()
                }
            }
        }
    }
}
extension LocationManager: CLLocationManagerDelegate {
    /// 認可状態の確認
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       switch status {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .denied:
            AlertController.showAlert(title: "位置情報の利用確認", message: "設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい", enableCancel: false)
        case .restricted:
            AlertController.showAlert(title: "位置情報の利用確認", message: "位置情報が取得できません。端末の設定の確認、または位置情報サービスが利用できる場所でご利用下さい", enableCancel: false)
       case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    /// 位置情報の取得時
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.isEmpty  {
            reject?(.location)
        } else {
            DeviceModel.currentLocation = locations[0]
            DeviceModel.searchLocationDateTime = Date()
            fulfill?(locations[0])
        }
        AppDelegate.sideMenu?.stopLocationRequest()
        reset()
    }
    
    /// 位置情報の取得失敗時
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        reject?(.location)
        reset()
        AppDelegate.sideMenu?.stopLocationRequest()
    }
}
