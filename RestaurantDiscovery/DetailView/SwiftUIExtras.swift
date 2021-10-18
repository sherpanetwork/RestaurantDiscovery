//
//  SwiftUIExtras.swift
//  RestaurantDiscovery
//
//  Created by Riley Hooper on 10/17/21.
//

import SwiftUI

public protocol ViewCoordinator {
    associatedtype Content
    @ViewBuilder func start() -> Content
}

public extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

public protocol EventHandler {
    associatedtype Event
    func send(_ event: Event)
}

public extension EventHandler {
    func send(_ event: DefaultEvent) {
        fatalError("Implemetation of send(_ event) needs to be implemented in the conforming class")
    }
}

public enum DefaultEvent {
    case defaultImplementation
}

public protocol Navigator {
    associatedtype Destination
    associatedtype Content
    @ViewBuilder func view(for destination: Destination) -> Content
}

public extension Navigator {
    @ViewBuilder func view(for destination: DefaultDestination) -> some View {
        Text("Implemetation of view(for:) needs to be implemented in the conforming class")
    }
}

public enum DefaultDestination {
    case defaultImplementation
}

public struct LazyView<Content: View>: View {
    @ViewBuilder var build: () -> Content

    public var body: some View {
        build()
    }
    
    public init(build: @escaping () -> Content) {
        self.build = build
    }
}
