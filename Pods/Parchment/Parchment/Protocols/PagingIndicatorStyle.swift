import Foundation
import SwiftUI

@available(iOS 14.0, *)
public protocol PagingIndicatorStyle: Sendable {
    associatedtype Body: View
    typealias Configuration = PagingIndicatorConfiguration
    @ViewBuilder func makeBody(configuration: Configuration) -> Body
}

@available(iOS 14.0, *)
struct PagingIndicator: View {
    let configuration: PagingIndicatorConfiguration

    @Environment(\.indicatorStyle) var style

    var body: some View {
        AnyView(style.makeBody(configuration: configuration))
    }
}

@available(iOS 14.0, *)
public struct PagingIndicatorConfiguration {
    public let backgroundColor: Color
}

@available(iOS 14.0, *)
struct DefaultPagingIndicatorStyle: PagingIndicatorStyle {
    func makeBody(configuration: Configuration) -> some View {
        Rectangle()
            .fill(configuration.backgroundColor)
    }
}

@available(iOS 14.0, *)
struct PagingIndicatorStyleKey: EnvironmentKey {
    static let defaultValue: any PagingIndicatorStyle = DefaultPagingIndicatorStyle()
}

@available(iOS 14.0, *)
extension EnvironmentValues {
    var indicatorStyle: any PagingIndicatorStyle {
        get { self[PagingIndicatorStyleKey.self] }
        set { self[PagingIndicatorStyleKey.self] = newValue }
    }
}

@available(iOS 14.0, *)
extension View {
    public func indicatorStyle(_ style: some PagingIndicatorStyle) -> some View {
        environment(\.indicatorStyle, style)
    }
}
