//
//  OnboardingView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 16.07.2026.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @State private var currentPage = 0
    private var isLastPage: Bool { currentPage == onboadingPages.count - 1 }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            TabView(selection: $currentPage) {
                ForEach(Array(onboadingPages.enumerated()), id: \.element.id) { index, page in
                    OnboardingPageView(page: page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)

            if !isLastPage {
                Button("Пропустить") {
                    complete()
                }
                .font(.body)
                .foregroundStyle(.secondary)
                .padding()
            }
            VStack {
                Spacer()
                pageIndicator
                actionButton
                    .padding(.bottom, 32)
            }
        }
    }
    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(onboadingPages.indices, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.accentColor : Color.secondary.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut, value: currentPage)
            }
        }
        .padding(.bottom, 16)
    }

    private var actionButton: some View {
        Button {
            if isLastPage {
                complete()
            } else {
                withAnimation { currentPage += 1 }
            }
        } label : {
            Text(isLastPage ? "Начать работу" : "Далее")
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .padding(.horizontal, 32)
    }

    private func complete() {
        hasCompletedOnboarding = true
    }
}

#Preview {
    OnboardingView()
}
