//
//  OnboardingPageView.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 16.07.2026.
//

import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingModel

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            ZStack {
                Circle()
                    .fill(page.tint.opacity(0.15))
                    .frame(width: 180, height: 180)
                    .padding(.bottom, 16)
                Image(page.imageName)
                    .resizable()
                    .frame(width: 300, height: 300)
                    .font(.system(size: 72, weight: .medium))
                    .foregroundStyle(page.tint)
                    .symbolRenderingMode(.hierarchical)
            }
            Text(page.title)
                .font(.title.bold())
                .multilineTextAlignment(.center)
            Text(page.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview("page 1") {
    let page = onboadingPages[0]
    OnboardingPageView(page: page)
}

#Preview("page 2") {
    let page = onboadingPages[1]
    OnboardingPageView(page: page)
}

#Preview("page 3") {
    let page = onboadingPages[2]
    OnboardingPageView(page: page)
}

#Preview("page 4") {
    let page = onboadingPages[3]
    OnboardingPageView(page: page)
}

#Preview("page 5") {
    let page = onboadingPages[4]
    OnboardingPageView(page: page)
}
