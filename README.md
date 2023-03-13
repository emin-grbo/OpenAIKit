# 📦 OpenAIKit
Simple networking layer written in Swift for interacting with OpenAI

It can serve as an insporation for creating a full-fledged package. In it's current state it is a helper to aid you get your app of the ground quickly and introduce you with various approaches when interacting with OpenAI models.

## 🙋‍♂️ How to use
- Get your API key:
[https://platform.openai.com/docs/introduction](https://platform.openai.com/)

- Add it as an SPM package via: https://github.com/emin-grbo/OpenAIKit

- import:
`import OpenAIKit`

## 📲 Example app
Within a repository there is a sample app which was written in a single file, just to demonstrate the overall approach.

## 💬 ChatGPT
To interact with Chat GPT, send the `ChatQuery` object along with your APIKey

`OpenAPI.chatGPT(_ query: ChatQuery, withToken token: String) async throws -> ChatResponse {`

It is important to note that ChatGPT works in such a way, where it needs the first message to be the system setting which determines how the AI will act. More on that [HERE](https://platform.openai.com/docs/guides/chat/instructing-chat-models)

```swift
public struct ChatQuery: Codable {
  var model: AiModel
  public var messages: [Message]
  // needs to have a default instruction in place: [Message(role: .system, content: "You are a helpful assistant")]
  }
```

Response is received in the following format:
```swift
public struct ChatResponse: Codable {
  public var id: String?
  public var object: String?
  public var created: Int?
  public var model: String?
  public var choices: [ChatChoice] = []
  public var usage: Usage?
}
```

Where the object `choices.first` contains the `message.content` which is the actual text response.

## 📓 Completions
To access various other models which performs completins, more on that [HERE](https://platform.openai.com/docs/guides/completion), use the following approach.

`OpenAPI.fetchCompletion(_ query: CompletionQueryModel, withToken token: String) async throws -> CompletionResponse {`

With the CompletionQueryModel being:
```swift
public struct CompletionQueryModel: Codable {
  public var model: AiModel
  public let prompt: String
  public var max_tokens: Int
  }
```
The main focus here is the `prompt` which holds the actualy task/question.

Response format is the same as for the Chat model

```swift
public struct CompletionResponse: Codable {
  public var id: String?
  public var object: String?
  public var created: Int?
  public var model: String?
  public var choices: [Choice] = []
  public var usage: Usage?
}
```

## 🎙️ Whisper Ai
Interacting with Whisper Ai is still not 100% fire-proof, as in personal experiments we noticed that one needs to wait at least a second for the file to get saved, before uploading it. This can cause some issues in usage, as well as the fact that if audio was not recorded correctly, ie no words are clear, OpenAi will respond with an error, saying that the audio file was corrupted.

`OpenAPI.whisperAi(withToken token: String, named fileName: String) async throws -> TranscribeResponse {`

Sending the proper audio file would send a simple text resonse in the following format.

```swift
public struct TranscribeResponse: Codable {
  public var text: String?
}
```













