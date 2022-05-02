//
//  CodingChallengeViewModel.swift
//  CodingChallenge
//
//  Created by Agnieszka Kot on 28/04/2022.
//

import Combine
import Foundation

class CodingChallengeViewModel: ObservableObject {

    let loadMoreSubject = PassthroughSubject<Void, Never>()
    let dateSelectedSubject = CurrentValueSubject<Date, Never>(Date())
    let showSelectedShiftDetails = PassthroughSubject<SingleShiftRowViewData, Never>()
    @Published var selectedDateShifts: AvaliableShiftsViewData?
    @Published var isModalPresenter: Bool = false
    @Published var modalViewData: ModalViewData?
    @Published var dates: [Date] = [Date]()

    private var cancellable = Set<AnyCancellable>()
    private var codingChallengeService: CodingChallengeServiceProtocol

    @Published private var allShiftsAvaliable: [AvaliableShiftsViewData] = [AvaliableShiftsViewData]()

    init(codingChallengeService: CodingChallengeServiceProtocol = CodingChallengeService()) {
        self.codingChallengeService = codingChallengeService
        bindCurrentSelection()
    }
    public func onAppear() {
        self.fetchShifts(for: "Dallas, TX", type: "week")
    }

    private func fetchShifts(for location: String, type: String) {
        codingChallengeService.fetchAvaliableShifts(for: location,
                                                       type: type)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure( let error):
                    print(error)
                case .finished: break
                }
            } receiveValue: { [weak self] recievedData in
                self?.dates = recievedData.data.map { data -> Date in DateTimeFormatter.stringToDate(string: data.date) }
                self?.allShiftsAvaliable = recievedData.data.map { data -> AvaliableShiftsViewData in
                    return AvaliableShiftsViewData(with: data)
                }
            }
            .store(in: &cancellable)
    }

    private func bindCurrentSelection() {
        dateSelectedSubject
            .combineLatest($allShiftsAvaliable) { ($0, $1) }
            .compactMap { [weak self] date, shifts -> AvaliableShiftsViewData? in
                let currentList = shifts.first(where: { shifts -> Bool in
                    return self?.isSameDayAndMonth(date1: shifts.weekDate, date2: date) ?? false
                })
                return currentList
            }
            .sink { [weak self] currentShifts in
                self?.selectedDateShifts = currentShifts
            }
            .store  (in: &cancellable)

        showSelectedShiftDetails
            .map { details in
                return ModalViewData(from: details)
            }
            .sink { [weak self] currentModalData in
                self?.modalViewData = currentModalData
            }
            .store(in: &cancellable)
    }

    private func isSameDayAndMonth(date1: Date, date2: Date) -> Bool {
        let dayDiff = Calendar.current.dateComponents([.day], from: date1, to: date2)
        let monthDiff = Calendar.current.dateComponents([.month], from: date1, to: date2)
        if dayDiff.day == 0 || monthDiff.month == 0 {
            return true
        } else {
            return false
        }
    }
}
