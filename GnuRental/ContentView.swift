import SwiftUI
import KeychainSwift

struct ContentView: View {
    
    let backGroundColor = Color(red: 60/255, green: 60/255, blue: 60/255, opacity: 1)
    
    // 응답으로 받을 토큰을 담을 구조체를 정의합니다.
    struct TokenResponse: Codable {
        let accessToken: String
        let refreshToken: String
    }
    
    @StateObject var rental = Rental()
    
    @State var path: [StackViewType] = []
    
    // Keychain instance
    let keychain = KeychainSwift()
    
    @State var accessToken: String = ""
    @State var refreshToken: String = ""
    
    @State var phoneNumber: String = "01099716737"
    @State var password: String = "411311"
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Spacer()
                HStack {
                    Button(action: {
                        path.append(.RentalListView)
                        
                    }, label: {
                        rentalButton
                    })
                    Button(action: {
                        path.append(.ReserveListView)
                    }, label: {
                        reserveButton
                    })
                }
                communityBox
                Spacer()
            }
            .padding()
            .background(backGroundColor)
            .navigationDestination(for: StackViewType.self) { stackViewType in
                switch stackViewType {
                case .RentalListView:
                    RentalListView(rental: rental, path: $path, accessToken: $accessToken)
                case .ReserveListView:
                    ReserveListView()
                default:
                    ErrorView()
                }
            }
        }
        .onAppear {
            //login() // 로그인하여 토큰을 가져옴
            loadRefreshToken() // 앱에 저장되어 있는 refreshToken을 가져옴
            //fetchAccessToken()
            login()
        }
    }
    
    
    // Save refresh token to Keychain
    func saveRefreshToken(token: String) {
        keychain.set(token, forKey: "refreshToken")
        print("saveRefreshToken: \(token)")
    }

    // Load refresh token from Keychain
    func loadRefreshToken() {
        refreshToken = keychain.get("refreshToken") ?? ""
        print("loadRefreshToken: \(refreshToken)")
    }
    
    func fetchAccessToken() {
        guard let refreshToken = keychain.get("refreshToken") else {
            print("No refresh token available.")
            return
        }

        guard let url = URL(string: "http://58.122.188.69:8080/auth/token") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = ["phoneNumber": "94955613", "refreshToken": refreshToken]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error during HTTP request: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                DispatchQueue.main.async {
                    // 저장된 토큰 업데이트
                    self.keychain.set(decodedResponse.accessToken, forKey: "accessToken")
                    self.keychain.set(decodedResponse.refreshToken, forKey: "refreshToken")
                    print("New Access Token: \(decodedResponse.accessToken)")
                    print("New Refresh Token: \(decodedResponse.refreshToken)")
                }
            } catch {
                print("Failed to decode response: \(error.localizedDescription)")
                login()
            }
        }.resume()
    }
    
    
    func login() {
        let url = URL(string: "http://58.122.188.69:8080/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 요청 바디에 포함될 JSON 데이터를 정의합니다.
        let requestBody = ["phoneNumber": phoneNumber, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 에러 체크
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // 응답 데이터 유효성 검사 및 디코딩
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
                DispatchQueue.main.async {
                    accessToken = decodedResponse.accessToken // accessToken 저장
                    saveRefreshToken(token: decodedResponse.refreshToken) // refreshToken 저장
                }
                print("Access Token: \(decodedResponse.accessToken)")
                print("Refresh Token: \(decodedResponse.refreshToken)")
                
            } catch {
                print("Error decoding response: \(error.localizedDescription)")
            }
        }.resume()
    }
}



private extension ContentView {
    
    var menuButton: some View {
        HStack {
            Spacer()
            Image(systemName: "line.3.horizontal.circle")
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(.white)
        }
        .padding(10)
    }

    var rentalButton: some View {
        Image("RentalButton")
            .resizable()
            .scaledToFit()
    }

    var reserveButton: some View {
        Image("ReserveButton")
            .resizable()
            .scaledToFit()
    }

    var communityBox: some View {
        HStack {
            Image("CommunityBox")
                .resizable()
                .scaledToFit()
        }
    }
    
}

#Preview {
    ContentView()
}






//Xcode 프로젝트 설정을 통해 ATS 설정 변경
//Xcode에서 프로젝트 열기: 프로젝트를 Xcode에서 엽니다.
//프로젝트 타겟 선택: Xcode의 상단 네비게이션 바에서 프로젝트 이름 옆에 있는 타겟을 선택합니다.
//Info 탭 이동: 타겟 설정에서 상단에 있는 Info 탭을 클릭합니다.
//Custom iOS Target Properties 섹션 찾기: 이 섹션 내에서 Info.plist 설정을 관리할 수 있습니다.
//+ 버튼 클릭: Custom iOS Target Properties 하단에 있는 + 버튼을 클릭하여 새로운 설정을 추가합니다.
//App Transport Security 설정 추가: 나타나는 드롭다운 메뉴에서 App Transport Security Settings를 선택하고, 추가된 설정을 확장합니다.
//Allow Arbitrary Loads 설정 추가: App Transport Security Settings 하위에 Allow Arbitrary Loads 설정을 추가하고, 이의 값을 YES로 설정합니다.
