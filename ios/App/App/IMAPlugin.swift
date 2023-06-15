//
//  IMAPlugin.swift
//  App
//
//  Created by Joshua Morony on 15/6/2023.
//

import Foundation
import Capacitor
import AVFoundation
import GoogleInteractiveMediaAds

@objc(IMAPlugin)
public class IMAPlugin: CAPPlugin {
    var adsLoader: IMAAdsLoader!
    var adsManager: IMAAdsManager!
    var audioPlayer: AVPlayer!
    var pluginCall: CAPPluginCall?
  
    @objc func playAd(_ call: CAPPluginCall) {
        guard let adTagUrl = call.options["adTagUrl"] as? String else {
            call.reject("Must provide a valid Ad Tag URL")
            return
        }

        pluginCall = call
        
        setupAdsLoader()
        requestAds(with: adTagUrl)
    }
  
    private func setupAdsLoader() {
        let settings = IMASettings()
        settings.autoPlayAdBreaks = false
        adsLoader = IMAAdsLoader(settings: settings)
        adsLoader.delegate = self
    }
  
    private func requestAds(with adTagUrl: String) {
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: bridge?.viewController?.view ?? <#default value#>, viewController: <#UIViewController?#>, companionSlots: nil)
        let request = IMAAdsRequest(adTagUrl: adTagUrl, adDisplayContainer: adDisplayContainer, contentPlayhead: nil, userContext: nil)
        adsLoader.requestAds(with: request)
    }
}

extension IMAPlugin: IMAAdsLoaderDelegate, IMAAdsManagerDelegate {
    public func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager) {
        audioPlayer.pause()
    }
    
    public func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager) {
        audioPlayer.play()
    }
    
    func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        let adsManager = adsLoadedData.adsManager
        adsManager?.delegate = self
        adsManager?.initialize(with: nil)
    }
    
    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        pluginCall?.reject("Failed to load ad")
    }

    func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        if event.type == IMAAdEventType.LOADED {
            // Ad loaded successfully, ready to play
            adsManager.start()
        } else if event.type == IMAAdEventType.ALL_ADS_COMPLETED {
            // All ads for the current break have completed
            pluginCall?.resolve(["result": true])
        }
    }
    
    func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        pluginCall?.reject("Ad manager received an error")
    }
}
