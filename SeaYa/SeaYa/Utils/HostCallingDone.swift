//
//  Card1View.swift
//  SeaYa
//
//  Created by 김하은 on 2023/07/17.
//

import SwiftUI

struct HostCallingDone: View {
    @ObservedObject var connectionManager: ConnectionService
    @State var clicked: Int? = 0
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        VStack {
            Text("그룹이 확정되었어요")
                .subtitle(textColor: Color.textColor)
                .padding(.top, 40)
            
            Image(userData.characterImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 150)
            Text(connectionManager.groupInfo?.scheduleName ?? "")
                .headline(textColor: Color.textColor)
                .padding(.top, 40)
                .padding(.bottom, 18)
            Divider()
                .frame(width: 214)
            Text("그룹이 생성되었어요. \n지금 바로 일정을 입력하세요!")
                .context(textColor: Color.textColor)
                .multilineTextAlignment(.center)
                .padding(.vertical,30)
            NavigationLink(
                destination: TimeTable(vm:TimeTableViewModel(selectedDay: getSelectedDate(connectionManager)))
                    .environmentObject(connectionManager)
                    .navigationBarBackButtonHidden(true),
                tag: 1,
                selection: $clicked) {}
            SmallButton_Blue(title: "일정 입력하기", action: {
                clicked = 1;
            })
            .padding(.bottom, 32)
        }
        .frame(width: 300)
        .background(Color.white)
        .cornerRadius(32)
        
    }
    func getSelectedDate(_ connectionManager: ConnectionService) -> [String]{
        if let arr = connectionManager.groupInfo{
            print("groupInfo 들어옴")
            return arr.selectedDate.map { date in
                DateUtil.getFormattedDate(date)
            }
        }
        else{
            print("groupInfo 안들어옴")
            return []
        }
    }
    
}


struct HostCallingDone_Previews: PreviewProvider {
    static var previews: some View {
        HostCallingDone(connectionManager: ConnectionService())
    }
}

