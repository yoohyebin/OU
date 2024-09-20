# 🗓️ 거리기반 그룹 스케줄링 앱 SeaYa!
<p align="center">
    <img width="500" alt="image" src="https://github.com/user-attachments/assets/ccc7f9a2-39e2-422f-ae78-d021280f0783">
</p>

>**개발기간: 2023.06 ~ 2023.08**

## 📖 프로젝트 소개

- SeaYa!는 근거리에 위치한 사람들끼리 그룹을 구성하여 약속잡는 것을 도와주는 앱입니다.
- 그룹에서 가장 많은 사람이 선택한 시간을 계산하여 약속 날짜와 시간을 추천합니다.
- 성사된 약속은 애플 캘린더에 바로 추가할 수 있습니다.

## ☺️ 멤버 소개
| **Helia** | **Kihyun** | **Samuel** | **Hani** | **Cindy** | **Gaon** |
| :------: |  :------: | :------: | :------: | :------: | :------: |
| iOS Developer | iOS Developer | iOS Developer | iOS Developer | Designer | Project Manager |

---

## 🔧 Stacks 

### Environment
![Xcode](https://img.shields.io/badge/Xcode-147EFB?style=for-the-badge&logo=Xcode&logoColor=white)
![Github](https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=GitHub&logoColor=white)               

### Development
![Swift](https://img.shields.io/badge/Swift-F05138?style=for-the-badge&logo=Swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-0086c8?style=for-the-badge&logo=Swift&logoColor=white)

### Communication
![Notion](https://img.shields.io/badge/Notion-000000?style=for-the-badge&logo=Notion&logoColor=white)


### Framework
**Multipeer Connectivity**
- 근거리에서 여러 기기 간에 데이터를 쉽게 전송할 수 있도록 해주는 프레임워크입니다.
- 근거리 사용자들끼리 그룹을 형성하는 데 사용되었습니다.


**EventKit**
- 캘린더와 리마인더에 접근하고 이들을 관리할 수 있도록 해주는 프레임워크입니다.
- 성사된 약속을 캘린더에 추가하는 데 사용되었습니다.
---
## ⭐ Main Feature
### 그룹 형성
- 사용자는 호스트가 되어 그룹을 만들거나, 게스트로서 기존 그룹에 참여할 수 있습니다.
- 호스트는 약속의 이름, 기간, 소요 시간을 설정한 후, 그룹원을 모집합니다.
  - 근처에 있는 사용자가 화면에 나타나며, 호스트는 원하는 사용자를 선택해 그룹에 초대할 수 있습니다.
- 게스트는 호스트가 초대를 수락할 때까지 대기합니다.


### 약속 추천
- 사용자는 자신의 가능한 시간을 선택합니다.
- 호스트는 그룹원들의 가용 시간을 확인한 후, 적합한 약속 시간을 선택할 수 있습니다.
  - 이때, 그룹원들이 가장 많이 선택한 시간이 상위에 표시되어 쉽게 일정을 결정할 수 있습니다.

### 캘린더 일정 추가
- 약속이 확정되면, 사용자는 약속을 자신의 캘린더에 추가할 수 있습니다.
---

## 🐈‍⬛ Git Branch
[Git 전략](https://github.com/yoohyebin/MC3-Team2-OU/wiki/SeaYa!-Wiki)

## 📂 Project Structure
```
├─ Legacy
│  └─ OnboardingView.swift
├─ DesignSystem
│  ├─ ButtonTheme.swift
│  ├─ Color+.swift
│  ├─ CustomModalSheet.swift
│  ├─ TextFieldTheme.swift
│  └─ Typography.swift
├─ Model
│  ├─ BoundedDate.swift
│  ├─ DateEvent.swift
│  ├─ DateMember.swift
│  ├─ Event.swift
│  ├─ GroupInfo.swift
│  ├─ LocalEvent.swift
│  ├─ MessageWrapper.swift
│  ├─ ScheduleDone.swift
│  ├─ TimeOks.swift
│  ├─ UserData.swift
│  ├─ UserSettings.swift
│  └─ WeekDay.swift
├─ View
│  ├─ ConfirmView
│  │  ├─ ConfirmDateModalView.swift
│  │  ├─ ConfirmMemberModalView.swift
│  │  ├─ ConfirmStartModalView.swift
│  │  └─ ConfirmView.swift
│  ├─ ContentView.swift
│  ├─ ExtraViews
│  │  ├─ CardBackgroundView.swift
│  │  ├─ CheckTimeDoneView.swift
│  │  ├─ GuestCallingDone.swift
│  │  ├─ GuestWaitingForConfirmView.swift
│  │  ├─ HostCallingDone.swift
│  │  ├─ LottieView.swift
│  │  ├─ ResultCardView.swift
│  │  ├─ ResultView.swift
│  │  └─ WaitingForConfirmView.swift
│  ├─ Host
│  │  ├─ CalendarView.swift
│  │  ├─ GuestListCellView.swift
│  │  ├─ GuestListView.swift
│  │  ├─ HostCallingView.swift
│  │  └─ MakingGroupView.swift
│  ├─ LaunchScreenView.swift
│  ├─ ListUpView
│  │  ├─ ListUpElementDetailView.swift
│  │  ├─ ListUpElementView.swift
│  │  └─ ListUpView.swift
│  ├─ MainView.swift
│  ├─ Onboarding
│  │  ├─ FixedTime
│  │  │  ├─ FixedTimeElementView.swift
│  │  │  ├─ FixedTimeView.swift
│  │  │  └─ SettingView.swift
│  │  ├─ NickNameView.swift
│  │  └─ OnboardingDoneView.swift
│  ├─ SettingView
│  │  ├─ NicknameEditView.swift
│  │  └─ UserInfoView.swift
│  └─ TimeTableView
│     ├─ RectangleView.swift
│     └─ TimeTable.swift
├─ Repository
│  ├─ LocalCalendarRepository.swift
│  ├─ RemoteCalendarRepository.swift
│  └─ UserInfoRepository.swift
├─ Service
│  ├─ CalcOksService.swift
│  ├─ CalendarService.swift
│  ├─ ConnectionService.swift
│  └─ TimeTableService.swift
├─ Utils
│  ├─ CustomAlert.swift
│  ├─ Date+.swift
│  ├─ DateUtil.swift
│  ├─ HapticsManager.swift
│  ├─ HomeView.json
│  ├─ View+.swift
│  ├─ pencil.json
│  └─ rank.json
└─ ViewModel
   ├─ FixedTimeViewModel.swift
   └─ TimeTableViewModel.swift
```
---

## 👩🏻‍💻 Role
- 서비스 기획
- 온보딩 화면, 메인 화면 UI 구현
- Apple Multipeer Connectivity 프레임워크를 활용한 근거리 통신 기능 구현

## 💡 Learnings and Insights
- Apple의 근거리 통신 프레임워크인 Multipeer Connectivity의 구조와 활용 방법에 대해 심도 있게 학습했습니다.
- Daily Scrum을 통해 팀원 간 효과적인 커뮤니케이션과 프로젝트 진행 상황 공유의 중요성을 체험했습니다.
- 다양한 배경을 가진 팀원들과의 협업을 통해 창의적인 문제 해결 능력을 향상시켰습니다.
- 의견 충돌 시 건설적인 토론을 통해 최선의 해결책을 도출하는 과정을 경험했습니다.
- 
---

### 개인 정보 보호 정책
[Privacy Policy.pdf](https://github.com/DeveloperAcademy-POSTECH/MC3-Team2-OU/files/12297144/privacy_policy.pdf)

### 앱스토어
[링크](https://apps.apple.com/kr/app/seaya/id6456751245)
