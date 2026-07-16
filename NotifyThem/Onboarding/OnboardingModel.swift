//
//  OnboardingModel.swift
//  NotifyThem
//
//  Created by Valery Zvonarev on 16.07.2026.
//

import SwiftUI

struct OnboardingModel: Identifiable {
    let id = UUID()
//    let symbolName: String // TODO: заменить на кастомные картинки
    let imageName: ImageResource // TODO: заменить на кастомные картинки
    let tint: Color
    let title: String
    let description: String
}

let onboadingPages: [OnboardingModel] = [
    OnboardingModel(imageName: .onboarding1Welcome, tint: .blue, title: "Добро пожаловать", description: "Отправляйте домашние задания и объявления ученикам - быстро, без бумаг и лишних чатов"),
    OnboardingModel(imageName: .onboarding2AddReceivers, tint: .green, title: "Добавьте получателей", description: "Заведите учеников один раз - и добавляйте их в нужные группы в дальнейшем"),
    OnboardingModel(imageName: .onboarding3CreateGroups, tint: .orange, title: "Создавайте группы", description: "Объединяйте учеников в группы - например, по классу или предмету - чтобы писать сразу всем"),
    OnboardingModel(imageName: .onboarding4SendMessage, tint: .pink, title: "Отправляйте сообщений", description: "Выберите группу и отправьте сообщение - оно сразу попадет в историю переписки этой группы"),
    OnboardingModel(imageName: .onboarding5CloudSync, tint: .teal, title: "Все сохраняется в облаке", description: "Данные синхронизируются через Firebase и доступны с любого устройства, с которого вы зайдете")
]

//let onboadingPages: [OnboardingModel] = [
//    OnboardingModel(symbolName: "text.bubble.fill", tint: .blue, title: "Добро пожаловать", description: "Отправляйте домашние задания и объявления ученикам - быстро, без бумаг и лишних чатов"),
//    OnboardingModel(symbolName: "person.fill.badge.plus", tint: .green, title: "Добавьте получателей", description: "Заведите учеников один раз - и добавляйте их в нужные группы в дальнейшем"),
//    OnboardingModel(symbolName: "person.3.fill", tint: .orange, title: "Создавайте группы", description: "Объединяйте учеников в группы - например, по классу или предмету - чтобы писать сразу всем"),
//    OnboardingModel(symbolName: "paperplane.fill", tint: .pink, title: "Отправляйте сообщений", description: "Выберите группу и отправьте сообщение - оно сразу попадет в историю переписки этой группы"),
//    OnboardingModel(symbolName: "checkmark.seal.fill", tint: .teal, title: "Все сохраняется в облаке", description: "Данные синхронизируются через Firebase и доступны с любого устройства, с которого вы зайдете")
//]
