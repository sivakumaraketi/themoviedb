//
//  SearchBarView.swift
//  TheMovieDB
//
//  Created by Siva kumar Aketi on 12/05/25.
//


import SwiftUI

/// A reusable search bar component with a text field with search icon
struct SearchBarView: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: AppConstants.Search.systemName)
                .foregroundColor(.gray)
            
            TextField(AppConstants.Search.searchTitle, text: $text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .accessibilityLabel(AppConstants.Search.accessiblitySearchTitle)
                .accessibilityHint(AppConstants.Search.accessiblitySearchHint)
            
            if !text.isEmpty {
                Button(action: {
                    withAnimation(.easeInOut) {
                        text = ""
                    }
                }) {
                    Image(systemName: AppConstants.Search.systemButtonName)
                        .foregroundColor(.gray)
                }
                .accessibilityLabel(AppConstants.Search.accessiblitySearch)
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1))
    }
}
