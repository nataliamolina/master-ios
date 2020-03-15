//
//  ConnectionManagerProtocol.swift
//  Master
//
//  Created by Carlos Mejía on 12/02/20.
//  Copyright © 2020 Master. All rights reserved.
//

import Foundation

typealias ResultBlock<T: Codable> = ((_ result: T?, _ error: CMError?) -> Void)

protocol ConnectionManagerProtocol {
    func setAuthenticationToken(_ token: String)
    func setCustomHeaders(_ headers: [String: String])
    func get<T: Codable>(url: String, onComplete: ResultBlock<T>?)
    func post<T: Codable>(url: String, request: Codable, onComplete: ResultBlock<T>?)
    func put<T: Codable>(url: String, onComplete: ResultBlock<T>?)
    func put<T: Codable>(url: String, request: Codable, onComplete: ResultBlock<T>?)
    func delete<T: Codable>(url: String, onComplete: ResultBlock<T>?)
    func deleteWithBoolResponse(url: String, onComplete: ResultBlock<BoolServerResponse>?)
    func getWithBoolResponse(url: String, onComplete: ResultBlock<BoolServerResponse>?)
    func putWithBoolResponse(url: String, onComplete: ResultBlock<BoolServerResponse>?)
}
