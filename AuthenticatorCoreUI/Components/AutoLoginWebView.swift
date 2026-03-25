/*
 Infomaniak Authenticator - iOS App
 Copyright (C) 2026 Infomaniak Network SA

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import AuthenticatorCore
import AuthenticatorResources
import InfomaniakCore
import InfomaniakDI
import SwiftUI
import WebKit

extension URL: @retroactive Identifiable {
    public var id: String {
        absoluteString
    }
}

public extension View {
    func autoLoginWebView(
        protectedURL: Binding<URL?>,
        userId: Int
    ) -> some View {
        modifier(AutoLoginWebViewModifier(protectedURL: protectedURL, userId: userId))
    }
}

public struct AutoLoginWebViewModifier: ViewModifier {
    @State private var isLoading = true

    @Binding var protectedURL: URL?
    let userId: Int

    public func body(content: Content) -> some View {
        content
            .sheet(item: $protectedURL) { url in
                NavigationStack {
                    AutoLoginWebView(protectedURL: url, userId: userId) { _ in
                        isLoading = false
                    } onLoadingFailed: {
                        protectedURL = nil
                    }
                    .overlay {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(.ultraThinMaterial)
                                .ignoresSafeArea()
                        }
                    }
                    .ignoresSafeArea(edges: [.bottom])
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(AuthenticatorResourcesStrings.closeButton, systemImage: "xmark", role: .cancel) {
                                protectedURL = nil
                            }
                        }
                    }
                }
            }
    }
}

public struct AutoLoginWebView: UIViewRepresentable {
    @Environment(\.openURL) private var openURL

    let protectedURL: URL
    let userId: Int
    let onPageLoaded: ((URL) -> Void)?
    let onLoadingFailed: (() -> Void)?

    public init(
        protectedURL: URL,
        userId: Int,
        onPageLoaded: ((URL) -> Void)?,
        onLoadingFailed: (() -> Void)?
    ) {
        self.protectedURL = protectedURL
        self.userId = userId
        self.onPageLoaded = onPageLoaded
        self.onLoadingFailed = onLoadingFailed
    }

    public class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        let parent: AutoLoginWebView

        init(_ parent: AutoLoginWebView) {
            self.parent = parent
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
            guard let pageURL = webView.url else { return }
            parent.onPageLoaded?(pageURL)
        }

        public func webView(_ webView: WKWebView,
                            decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
            if navigationAction.navigationType == .linkActivated {
                if let url = navigationAction.request.url {
                    parent.openURL(url)
                }
                return .cancel
            }

            if let url = navigationAction.request.url,
               url.host(percentEncoded: false) == Constants.managerHost {
                return .allow
            }

            parent.onLoadingFailed?()
            return .cancel
        }
    }

    private func loadProtectedURL(in webView: WKWebView) {
        Task {
            guard let autoLoginURL = Constants.autologinURL(to: protectedURL) else {
                onLoadingFailed?()
                return
            }

            @InjectService var tokenStore: TokenStore
            guard let accessToken = tokenStore.tokenFor(userId: userId)?.apiToken.accessToken else {
                onLoadingFailed?()
                return
            }

            var autoLoginURLRequest = URLRequest(url: autoLoginURL)
            autoLoginURLRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

            webView.load(autoLoginURLRequest)
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.scrollView.bounces = false
        webView.scrollView.bouncesZoom = false
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = true
        webView.scrollView.alwaysBounceVertical = false
        webView.scrollView.alwaysBounceHorizontal = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never

        loadProtectedURL(in: webView)

        return webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        // needed for UIViewRepresentable
    }
}
