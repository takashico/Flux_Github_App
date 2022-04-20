//
//  UserListItemView.swift
//  FluxGithubApp
//
//  Created by Takahashi Shiko on 2022/04/21.
//

import SwiftUI

struct UserListItemView: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            
            Text("ユーザー名")
                .font(.system(size: 16))
            
            Spacer()
        }
        .padding(.vertical, 10)
    }
}

struct UserListItemView_Previews: PreviewProvider {
    static var previews: some View {
        UserListItemView()
    }
}
