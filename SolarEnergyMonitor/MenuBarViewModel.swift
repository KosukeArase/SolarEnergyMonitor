import Foundation
import Combine

struct ApiResponse: Codable {
    let dateTime: DateTime
    let instantPower: InstantPower
}

struct DateTime: Codable {
    let year: Int
    let month: Int
    let day: Int
    let hour: Int
    let minute: Int
    let second: Int
}

struct InstantPower: Codable {
    let consumedPower: Int
    let pcsGeneratedPower: Int
}

class MenuBarViewModel: ObservableObject {
    @Published var generatedPower: Int = 0
    @Published var consumedPower: Int = 0

    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private var session: URLSession?

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 3
        configuration.timeoutIntervalForResource = 3
        self.session = URLSession(configuration: configuration)
        print("init")

        startFetching()
    }
    
    func startFetching() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.fetchData()
        }
        fetchData()
    }
    
    func fetchData() {
        let timeStamp = Int(Date().timeIntervalSince1970)
        guard var components = URLComponents(string: "http://192.168.2.107/asyncquery.cgi") else { return }
        components.queryItems = [
            URLQueryItem(name: "type", value: "Navi"),
            URLQueryItem(name: "timeStamp", value: "\(timeStamp)")
        ]
        
        guard let url = components.url else {
            print("Failed to create URL")
            return
        }

        self.session?.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ApiResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.generatedPower = 0
                    self.consumedPower = 0
                }
            }, receiveValue: { [weak self] response in
                self?.updateDisplayText(with: response)
            })
            .store(in: &cancellables)
    }
    
    private func updateDisplayText(with response: ApiResponse) {
        let dateTime = response.dateTime
        consumedPower = response.instantPower.consumedPower
        generatedPower = response.instantPower.pcsGeneratedPower
    }
    
    deinit {
        timer?.invalidate()
    }
}
