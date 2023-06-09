import Foundation
import AVFoundation

class Endpoint {
  // force unwrap because if this endpoint is bad, it should fail immediately and loudly
  static let chatAi = URL(string: "https://api.openai.com/v1/chat/completions")!
  static let whisperAi = URL(string: "https://api.openai.com/v1/audio/transcriptions")!
}

enum HttpMethod: String {
  // not using anything else so 🤷‍♂️
  case POST
}

public class OpenAPI {
  
  public static func chatGPT(_ query: ChatQuery, withToken token: String) async throws -> ChatResponse {
    var request = URLRequest(url: Endpoint.chatAi)
    request.httpBody = try JSONEncoder().encode(query)
    request.httpMethod = HttpMethod.POST.rawValue
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let (data, _) = try await URLSession.shared.data(for: request)
    return try decodeOrThrow(data: data)
  }
  
  public static func whisperAi(withToken token: String, named fileName: String) async throws -> TranscribeResponse {
    
    guard let fileURL = fileURL(forName: fileName), let audioData = try? Data(contentsOf: fileURL)
    else { throw OpenAIError.custom(description: "bad audio") }
    
    let boundary = "Boundary-\(UUID().uuidString)"
    
    var request = URLRequest(url: Endpoint.whisperAi)
    request.httpMethod = HttpMethod.POST.rawValue
    
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let httpBody = NSMutableData()
    httpBody.appendString(convertFormField(named: "model", value: "whisper-1", using: boundary))
    httpBody.append(convertFileData(fieldName: "file",
                                    fileName: "\(fileName).m4a",
                                    mimeType: "audio/mp4",
                                    fileData: audioData,
                                    using: boundary))
    httpBody.appendString("--\(boundary)--")
    request.httpBody = httpBody as Data
    
    let (data, _) = try await URLSession.shared.data(for: request)
    return try decodeOrThrow(data: data)
  }
  
  public static func fetchCompletion(_ query: CompletionQueryModel, withToken token: String) async throws -> CompletionResponse {
    let url = URL(string: "https://api.openai.com/v1/completions")!
    var request = URLRequest(url: url)
    request.httpBody = try JSONEncoder().encode(query)
    request.httpMethod = HttpMethod.POST.rawValue
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    let (data, _) = try await URLSession.shared.data(for: request)
    return try decodeOrThrow(data: data)
  }
  
  private static func decodeOrThrow<T:Codable>(data: Data) throws -> T {
    do {
      let result = try JSONDecoder().decode(T.self, from: data)
      return result
    } catch {
      throw error
    }
  }
}

// MARK: Helpers
private extension OpenAPI {
  private static func fileURL(forName name: String) -> URL? {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let realURL = documentsDirectory.appendingPathComponent("\(name).m4a")
    return realURL
  }
  
  static func convertFormField(named name: String, value: String, using boundary: String) -> String {
    var fieldString = "--\(boundary)\r\n"
    fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
    fieldString += "\r\n"
    fieldString += "\(value)\r\n"
    
    return fieldString
  }
  
  static func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
    let data = NSMutableData()
    
    data.appendString("--\(boundary)\r\n")
    data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
    data.appendString("Content-Type: \(mimeType)\r\n\r\n")
    data.append(fileData)
    data.appendString("\r\n")
    
    return data as Data
  }
}
