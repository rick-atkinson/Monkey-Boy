//
//  TransformationState.swift
//  Monkey Boy
//
//  Created by Rick Atkinson on 1/21/26.
//

import Foundation

enum TransformationState: Equatable {
    case idle
    case selectingMonkey
    case transforming
    case completed
    case error(TransformationError)

    static func == (lhs: TransformationState, rhs: TransformationState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
             (.selectingMonkey, .selectingMonkey),
             (.transforming, .transforming),
             (.completed, .completed):
            return true
        case let (.error(lhsError), .error(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
