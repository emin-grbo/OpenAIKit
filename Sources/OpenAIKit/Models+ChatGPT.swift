import Foundation

public enum MessageRole: String, Codable {
  case system
  case user
  case assistant
}

public struct Message: Codable {
  public let role: MessageRole
  public let content: String
  
  public init(role: MessageRole, content: String) {
    self.role = role
    self.content = content
  }
}

public struct ChatQuery: Codable {
  var model: AiModel
  public var messages: [Message]
  // needs to have a default instruction in place: [Message(role: .system, content: "You are a helpful assistant")]
  
  public init(messages: [Message]) {
    self.model = .chatGPT
    self.messages = messages
  }
}

public struct ChatResponse: Codable {
  public var id: String?
  public var object: String?
  public var created: Int?
  public var model: String?
  public var choices: [ChatChoice] = []
  public var usage: Usage?
}

public struct ChatChoice: Codable {
  public var message: Message
//  var index: Int?
//  var logprobs: String?
//  var finishReason: String?
}
