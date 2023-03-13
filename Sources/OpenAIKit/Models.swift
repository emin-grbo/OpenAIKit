import Foundation

// Used but regular completion models
public struct CompletionResponse: Codable {
  public var id: String?
  public var object: String?
  public var created: Int?
  public var model: String?
  public var choices: [Choice] = []
  public var usage: Usage?
}

public struct CompletionQueryModel: Codable {
  public var model: AiModel
  public let prompt: String
  public var max_tokens: Int
  
  public init(model: AiModel, prompt: String, max_tokens: Int = 4000) {
    self.model = model
    self.prompt = prompt
    self.max_tokens = max_tokens
  }
}

public enum AiModel: String, Codable {
  case chatGPT = "gpt-3.5-turbo"
  case daVinci3 = "text-davinci-003"
  case curie1 = "text-curie-001"
  case babbage1 = "text-babbage-001"
  case ada1 = "text-ada-001"
  case codexDavinci2 = "code-davinci-002"
  case codexCushman = "code-cushman-001"
  case daVinciEdit = "text-davinci-edit-001"
  
  var tokenMax: Int {
    switch self {
    case .chatGPT:
      return 4000
    case .daVinci3:
      return 4000
    case .curie1:
      return 2000
    case .babbage1:
      return 2000
    case .ada1:
      return 2000
    case .codexDavinci2:
      return 4000
    case .codexCushman:
      return 2048
    case .daVinciEdit:
      return 4000
    }
  }
}

public struct ErrorResponse: Codable {
  let error: ErrorContent
}

public struct ErrorContent: Codable {
  let message: String?
  let type: String?
  //  let param: String?
  //  let code: String?
}

public struct Choice: Codable {
  public var text: String?
  public var index: Int?
  public var logprobs: String?
  public var finishReason: String?
  
  enum CodingKeys: String, CodingKey {
    case text, index, logprobs
    case finishReason = "finish_reason"
  }
}

public struct Usage: Codable {
  public var promptTokens: Int?
  public var completionTokens: Int?
  public var totalTokens: Int?
  
  enum CodingKeys: String, CodingKey {
    case promptTokens = "prompt_tokens"
    case completionTokens = "completion_tokens"
    case totalTokens = "total_tokens"
  }
}

public enum OpenAIError: Error {
case custom(description: String)
}
