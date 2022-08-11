//
//  LazyNavigationLink.swift
//
//
//  Created by Pavlo Naumenko on 8/11/22.
//

import SwiftUI

/// A view that controls a navigation presentation.
/// Unlike NavigationLink, LazyNavigationLink initiates its destination in lazy loading manier.
/// That means only after LazyNavigationLink is pressed the destination view will be initiated and presented.
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct LazyNavigationLink<Label, Destination> : View where Label : View, Destination : View {
    
    //MARK: Private properties
    
    private let destination: () -> Destination
    private let label: Label
    
    @State private var presentView = false
    
    /// Creates a navigation link that presents the destination view.
    /// - Parameters:
    ///   - destination: A view for the navigation link to present.
    ///   - label: A view builder to produce a label describing the `destination` to present.
    public init(@ViewBuilder destination: @escaping () -> Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
    }
    
    public var body: some View {
        NavigationLink(isActive: $presentView, destination: destinationView) {
            label
        }
    }
    
    @ViewBuilder
    func destinationView() -> some View {
        if presentView {
            destination()
        } else {
            EmptyView()
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension LazyNavigationLink where Label == Text {
    /// Creates a navigation link that presents a destination view, with a text label
    /// that the link generates from a localized string key.
    /// - Parameters:
    ///   - titleKey: A localized string key for creating a text label.
    ///   - destination: A view for the navigation link to present.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder destination: @escaping () -> Destination) {
        self.destination = destination
        self.label = Text(titleKey)
    }
    
    /// Creates a navigation link that presents a destination view, with a text label
    /// that the link generates from a title string.
    /// - Parameters:
    ///   - title: A string for creating a text label.
    ///   - destination: A view for the navigation link to present.
    public init<S>(_ title: S, @ViewBuilder destination: @escaping () -> Destination) where S : StringProtocol {
        self.destination = destination
        self.label = Text(title)
    }
}
