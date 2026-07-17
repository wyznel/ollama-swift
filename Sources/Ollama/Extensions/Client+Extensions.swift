//
//  Client+Extensions.swift
//  Ollama
//
//  Created by Ben Herbert on 17/07/2026.
//

public struct PullProgress: Decodable, Sendable {
    public let status: String
    public let digest: String?
    public let total: Int?
    public let completed: Int?
}

extension Client {
    /// Downloads a model from the Ollama library.
    ///
    /// - Parameters:
    ///   - id: The name of the model to pull.
    ///   - insecure: If true, allows insecure connections to the library. Only use this if you are pulling from your own library during development.
    /// - Returns: `true` if the model was successfully pulled, otherwise `false`.
    /// - Throws: An error if the operation fails.
    ///
    /// - Note: Cancelled pulls are resumed from where they left off, and multiple calls will share the same download progress.
    public func pullModelStream(
        _ id: Model.ID,
        insecure: Bool = false
    ) -> AsyncThrowingStream<PullProgress, Swift.Error> {
        let params: [String: Value] = [
            "name": .string(id.rawValue),
            "insecure": .bool(insecure),
            "stream": true,
        ]
        return fetchStream(.post, "/api/pull", params: params)
    }
}
