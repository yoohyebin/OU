//
//  MakingGroupView.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/17.
//

import SwiftUI

//TODO: 다음 view로 넘어갈 때 입력받은 정보 저장
struct MakingGroupView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var userData: UserData
    @ObservedObject var connectionManager: ConnectionService
    
    @State private var scheduleName: String = ""
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    @State private var selectedDate = [Date]()
    @State private var moveToNextView = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("일정 제목")
                    .headline(textColor: Color.textColor)
                    .padding(EdgeInsets(top: 34, leading: 16, bottom: 0, trailing: 0))
                
                TextFieldTheme(placeholder: "제목을 입력하세요", input: $scheduleName)
                    .padding(EdgeInsets(top: 6, leading: 16, bottom: 0, trailing: 16))
                
                
                Text("기간 설정")
                    .headline(textColor: Color.textColor)
                    .padding(EdgeInsets(top: 39, leading: 16, bottom: 0, trailing: 0))
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(maxWidth: 358, maxHeight: 200)
                        .cornerRadius(16)
                    
                    CalendarView(choseDate: $selectedDate)
                        .padding(16)
                    
                }
                .padding(EdgeInsets(top: 6, leading: 16, bottom: 0, trailing: 16))
                
                Text("소요 시간 지정")
                    .headline(textColor: Color.textColor)
                    .padding(EdgeInsets(top: 39, leading: 16, bottom: 0, trailing: 0))
                
                HStack {
                    Picker("Hour", selection: $selectedHour) {
                        ForEach(0..<16) { hour in
                            Text("\(hour)시간")
                        }
                    }
                    .pickerStyle(.wheel)
                    .clipped()
                    
                    Picker("Minute", selection: $selectedMinute) {
                        ForEach([0, 30], id: \.self) { minute in
                           Text("\(minute)분")
                        }
                    }
                    .pickerStyle(.wheel)
                    .clipped()
                }
                .frame(minHeight: 150)
                
                BigButton_Blue(
                    title: "다음",
                    action: {
                        moveToNextView = true
                    }
                )
                .padding(EdgeInsets(top: 30, leading: 16, bottom: 25, trailing: 16))
                
                NavigationLink(
                    destination: HostCallingView(
                                    connectionManager: connectionManager,
                                    scheduleName: $scheduleName,
                                    selectedDate: $selectedDate,
                                    estimatedTime: .constant(selectedMinute == 30 ? selectedHour*2+1 : selectedHour*2)
                                )
                                .navigationBarBackButtonHidden()
                                .environmentObject(userData),
                    isActive: $moveToNextView,
                    label: {
                        EmptyView()
                    })
            }
            .background(Color.backgroundColor)
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar { // <2>
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("방 만들기")
                            .body(textColor: Color.black)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .tint(Color.black)
                    })
                }
            }
        }
    }
}

struct MakingGroupView_Previews: PreviewProvider {
    static var previews: some View {
        MakingGroupView(connectionManager: ConnectionService())
    }
}
