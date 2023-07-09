//
//  CatListView.swift
//  TCA-Composable-Architecture-Sample-App
//
//  Created by Daniyal Yousuf on 2023-07-08.
//

import ComposableArchitecture
import SwiftUI


struct CatList: ReducerProtocol {
    struct State: Equatable {
        var cats: [CatListModel] = []
        var isFetching: Bool = true
    }
    
    enum Action: Equatable {
        case catListResponse(TaskResult<[CatListModel]>)
        case fetchCatList(String)
    }
    
    @Dependency(\.catListClient) var catListClient
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .catListResponse(.success(catList)):
            state.isFetching = false
            state.cats = catList
            return .none
        case let .catListResponse(.failure(error)):
            print(error.localizedDescription)
            return .none
        case let .fetchCatList(endPoint):
            return .run { send in
                await send(
                    .catListResponse(
                        TaskResult {
                            try await self.catListClient.fetchCats(endPoint)
                        }
                    )
                )
            }
        }
    }
}

struct CatListView: View {
    let store: StoreOf<CatList>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            catListView(viewStore: viewStore)
            .task {
                do {
                    await viewStore.send(.fetchCatList("/v1/breeds")).finish()
                }
            }
        }
    }
    
    @ViewBuilder
    func catListView(viewStore: ViewStore<CatList.State, CatList.Action>) -> some View {
        VStack {
            if viewStore.isFetching {
                ProgressView()
            } else {
                List {
                    ForEach(viewStore.cats) { cat in
                        Text(cat.name ?? "")
                            .font(.body)
                            .fontWeight(.regular)
                    }
                }
            }
        }
    }
}


struct CatListView_Previews: PreviewProvider {
    static var previews: some View {
        CatListView(store: Store(initialState: CatList.State(), reducer: {
            CatList()
        }))
    }
}
