import Foundation

enum MessageRole: String, Codable {
  case system
  case user
  case assistant
}

struct Message: Codable {
  let role: MessageRole
  let content: String
}

struct ChatQuery: Codable {
  var model: AiModel = .chatGPT
  var messages: [Message]
  // needs to have a default instruction in place: [Message(role: .system, content: "You are a helpful assistant")]
}

struct ChatResponse: Codable {
  var id: String?
  var object: String?
  var created: Int?
  var model: String?
  var choices: [ChatChoice] = []
  var usage: Usage?
}

struct ChatChoice: Codable {
  var message: Message
//  var index: Int?
//  var logprobs: String?
//  var finishReason: String?
}
