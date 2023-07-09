//
//  TCA_Composable_Architecture_Sample_AppApp.swift
//  TCA-Composable-Architecture-Sample-App
//
//  Created by Daniyal Yousuf on 2023-07-08.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_Composable_Architecture_Sample_AppApp: App {
    var body: some Scene {
        WindowGroup {
            CatListView(store: Store(initialState: CatList.State(), reducer: {
                CatList()
                    ._printChanges()
            }))
        }
    }
}
