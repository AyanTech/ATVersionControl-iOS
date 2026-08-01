//
//  CheckVersionResponseDTO.swift
//  ATVersionControl
//

struct CheckVersionResponseDTO: Decodable, Sendable {
    let updateStatus: UpdateStatus?

    enum CodingKeys: String, CodingKey {
        case updateStatus = "UpdateStatus"
    }
}
