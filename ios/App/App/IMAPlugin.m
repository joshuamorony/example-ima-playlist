//
//  IMAPlugin.m
//  App
//
//  Created by Joshua Morony on 15/6/2023.
//

#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>
// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(IMAPlugin, "IMAPlugin",
           CAP_PLUGIN_METHOD(playAd, CAPPluginReturnPromise);
)
