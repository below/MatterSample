//
//  ContentView.swift
//  MatterCommissionerPOC
//
//  Created by Alexander von Below on 12.09.22.
//

import SwiftUI
import HomeKit
import Matter
import MatterSupport

// Prerequisites

// https://download.developer.apple.com/iOS/iOS_Logs/EnableMatter_Instructions.pdf

// https://developer.apple.com/documentation/homekit/hmaccessorysetupmanager/3920433-performmatterecosystemaccessorys

// https://github.com/SiliconLabs/matter/blob/release_0.2.0/docs/guides/simulated_device_linux.md

// https://github.com/project-chip/connectedhomeip/blob/master/docs/guides/darwin.md#profile-installation

struct ContentView: View {
    
    @State private var showingAlert = false
    @State private var error: Error?
    var body: some View {
        VStack {
            Button("Perform Matter Request") {
                Task {
                    await performMatterRequest()
                }
            }
        }
        .padding()
        .alert("Error Performing Request",
               isPresented: $showingAlert,
               actions: {},
               message: {
            if let description = String(describing: self.error) {
                Text(description)
            }
        }
        )
    }
    
    func performMatterRequest(
        ecosystemName: String = "My Ecosystem",
        homeName: String = "My Home") async {
            
            let magentaHome = MatterAddDeviceRequest.Home(displayName: homeName)
            let topology = MatterAddDeviceRequest.Topology(
                ecosystemName: ecosystemName,
                homes: [magentaHome])
            let request = MatterAddDeviceRequest(topology: topology)
            do {
                try await request.perform()
            } catch {
                self.error = error
                showingAlert = true
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

