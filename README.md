# ShopLive iOS Project Report

## 개요

요구된 모든 기능 및 가산점 항목을 구현했으며, 본 문서에는 본인이 고민한 것들에 대해 기술합니다.

## 목차

1. 기술 스택
2. 아키텍처
3. Scheme
4. 의존성 주입
5. API 호출 결과
6. Favorite 기록을 위한 Persistant Storage
7. Unit Test
8. Secret Key 관리
9. Git 전략

## 1. 기술 스택

- Base
  - Swift, AutoLayout, Combine
- Framework(SPM)
  - [SnapKit](https://github.com/SnapKit/SnapKit) : AutoLayout Syntactic Sugar
  - [Swinject](https://github.com/Swinject/Swinject) : Runtime Dependency Injection Container
  - [Kingfisher](https://github.com/onevcat/Kingfisher) : Image Caching Util

## 2. 아키텍처

> MVVM + CleanArchitecture

![Architecture](https://github.com/kcharliek/MarvelShop/assets/26176588/938c77ab-aed1-453b-9fbb-c5332e238053)

### (1) Presentation Layer

1. View (UIViewController) : 유저에게 노출되는 UI 렌더링.
2. Router : Navigation / Modal 등. 화면 이동을 담당.

### (2) Gateway Layer

1. ViewModel : Business Logic 구현. (User Interaction 의 해석 및 Repository 와의 Data 흐름 중계)
2. Repository : Business Logic 내 Data 관련 흐름 포함.

### (3) Domain Layer

1. Model : 서비스의 기반이 되는 App Model. ex) MCharacter

### (4) Data Layer

1. DataStore : Server/Database 관련 로직 은닉 및 DTO(JSON 등 Raw Data) 와 App Model의 상호 변환 담당.

## 3. Scheme

![스크린샷 2024-04-01 오후 3 56 28](https://github.com/kcharliek/MarvelShop/assets/26176588/19dc58c6-5cf4-4978-b8d4-5a8fb75f6964)

1. MarvelShop : Main App
2. MockSample : Sample App With Mock Data
3. MarvelShopTests  : For Unit Test

## 4. 의존성 주입

> 추상화, 구현체 변경, Testability를 목적으로 의존성 분리했으며, 이에 구현체 주입이 필요합니다.

- 추상화
  - Search 탭과 Favorite 탭은 동일 UI, 일부 로직만 다른 상황으로 이해했습니다. View를 재사용했고, 로직이 담긴 ViewModel을 추상화하여 각 구현체를 주입하는 방식으로 구현했습니다.
- 구현체 변경
  - Network 의존적이지 않은 샘플 앱을 구성했습니다. Compile 시점에 일반 시나리오 혹은, 샘플 시나리오를 선택하여 구현체를 주입하게됩니다.
- Testability
  - Repository, DataStore를 추상화하여 Mock을 주입하는 식으로 ViewModel 시나리오를 테스트했습니다. 
- 구현
  - DI Container(Swinject) 를 Singleton 으로 관리했습니다.

## 5. API 호출 결과

1. 프록시 툴([Proxyman](https://proxyman.io/))을 이용한 HTTP Request Capture

- Pagination 시나리오

> Offset 10씩 증가

![스크린샷 2024-04-01 오후 4 02 06](https://github.com/kcharliek/MarvelShop/assets/26176588/7caf7790-0646-410a-8cb4-e44f273118fa)

- 검색 시나리오

> "Man" 검색

![스크린샷 2024-04-01 오후 4 03 49](https://github.com/kcharliek/MarvelShop/assets/26176588/0b1dc57f-b24a-4831-bc13-723e5aff01f7)

2. 앱 내 구현한 Network Debugger를 이용한 Request / Response 조회

![Simulator Screenshot - iPhone 15 Pro Max - 2024-04-01 at 16 07 14-imageonline co-merged](https://github.com/kcharliek/MarvelShop/assets/26176588/31e02743-1d25-400c-9d80-d13cd3a94911)


## 6. Favorite 기록을 위한 Persistant Storage

- 개발 경험에 비추어 생각했을 때, Favorite 리소스는 향후 Query 기반 조회가 필요할 것으로 예상되며, 앱의 핵심 컨텐츠인 만큼 CRUD 빈도가 높아서 성능 관점에서 고려해야할 것으로 보입니다. 이를 근거로 언젠가 CoreData 등 Database의 적용이 필요할 것으로 생각합니다.
- 하지만 현재 스펙에는 최대 5개만 기록한다고 명시되어있고, 과제 상황임을 고려했을 때, 구현 및 유지보수 부하가 높은 Database 를 사용하는 것은 현시점 오버엔지니어링이라는 판단입니다. 이를 근거로 Key-Value 기반의 UserDefaults 를 선택했습니다. 또한 UserDefaults 구현체와 의존성 분리되어있으므로, 향후 Database로의 이주 또한 문제 없을 것입니다.

## 7. Unit Test

- 검색 탭
  - View(User Interaction)와 Data(Repository / DataStore) 를 Mocking하여 ViewModel 로직 테스트
    - User Interaction (ViewDidLoad, Character Touch, Input Query) 에 따른 정상 Output 테스트
    - Pagination 정상 동작 여부 테스트
- Networking
  - Networking Framework에 대해, URLRequest 정상 생성 여부 테스트

## 8. Secret Key 관리

### (1) 결론 

- iOS 빌드안에 하드코딩된 Secret Key를 두어서는 안됩니다. 구현 방법을 막론하고 해당 값을 꺼내는 것은 문자 그대로 시간 문제이기 때문입니다.

### (2) 어떻게 할 것인가

- 앱이 리소스에 직접 접근하는 것이 아닌, 백엔드가 접근하고 이를 앱에 중계하는 식으로 구현합니다. 백엔드가 앱의 정상 요청 여부를 검증하는 방법은 무수히 많고 (HMAC, Authorization 등), 만일 Key가 탈취되었다고 하더라도 이를 동적으로 대응할 수 있기 때문입니다.

### (3) 작업 내용

- 백엔드를 구성하는 것은 과제 내용 밖의 문제로 판단, 최소한의 대응을 했습니다. Git Repository에 노출되지 않도록 Key값이 포함된 파일을 gitignore하고, 개발자간 직접 해당 파일을 주고 받도록 업무 방식을 산정했습니다.

## 9. Git 전략

- 그동안 Git-Flow를 통해 업무해왔으며, feature 단위로 브랜치를 나누어, Pull-Request 를 통해 머지 했습니다.
