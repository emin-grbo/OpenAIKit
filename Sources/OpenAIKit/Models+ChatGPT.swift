import Foundation

public enum MessageRole: String, Codable {
  case system
  case user
  case assistant
}

public struct Message: Codable {
  let role: MessageRole
  let content: String
}

public struct ChatQuery: Codable {
  var model: AiModel
  public var messages: [Message]
  // needs to have a default instruction in place: [Message(role: .system, content: "You are a helpful assistant")]
  
  init(messages: [Message]) {
    self.model = .chatGPT
    self.messages = messages
  }
}

public struct ChatResponse: Codable {
  var id: String?
  var object: String?
  var created: Int?
  var model: String?
  var choices: [ChatChoice] = []
  var usage: Usage?
}

public struct ChatChoice: Codable {
  var message: Message
//  var index: Int?
//  var logprobs: String?
//  var finishReason: String?
}
