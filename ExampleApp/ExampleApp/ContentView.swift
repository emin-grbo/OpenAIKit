#warning("note")
// this example app was made only to showcase how one could interact with the SPM in the simples manner possible.
// as such it has no architecture or ironed our approach, just pure functionality.

import OpenAIKit
import SwiftUI
import AVKit

struct ContentView: View {
  
  // loading states
  @State var isLoadingChat: Bool = false
  @State var isLoadingAi: Bool = false
  @State var isLoadingWhisper: Bool = false
  
  @State var chatResponse: String = ""
  @State var aiResponse: String = ""
  @State var whisperResponse: String = ""
  
  // recording audio states
  @State var isRecording = false
  @State var session : AVAudioSession!
  @State var recorder : AVAudioRecorder!
  
  var body: some View {
    VStack(spacing: 60) {
      
      // MARK: Chat GPT Example
      GroupBox(
        label: Text("Chat GPT"),
        content: {
          Button {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            AudioServicesPlaySystemSound(1306)
            let query = ChatQuery(messages: [
              Message(role: .system, content: "you are a helpful assistant"),
              Message(role: .user, content: "hi there!")])
            
            Task {
              isLoadingChat = true
              let res = try? await OpenAPI.chatGPT(query, withToken: "<YOUR-API-KEY>")
              let chatResponseMessage = res?.choices.first?.message.content ?? "⚠️"
              print(chatResponseMessage)
              chatResponse = chatResponseMessage
              isLoadingChat = false
            }
          } label: {
            if isLoadingChat {
              ProgressView()
            } else {
              Text("Say Hi")
            }
          }
          .buttonStyle(.bordered)
          
          if !chatResponse.isEmpty {
            Text(chatResponse)
          }
        }
      )
      .tint(.green)
      
      // MARK: Completion Ai Example
      GroupBox(
        label: Text("daVinci Ai"),
        content: {
          Button {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            AudioServicesPlaySystemSound(1306)
            
            let query = CompletionQueryModel(model: .daVinci3, prompt: "Hello, how are you?")
            
            Task {
              isLoadingAi = true
              let res = try? await OpenAPI.fetchCompletion(query, withToken: "<YOUR-API-KEY>")
              let aiResponseMessage = res?.choices.first?.text ?? "⚠️"
              print(aiResponseMessage)
              aiResponse = aiResponseMessage
              isLoadingAi = false
            }
          } label: {
            if isLoadingAi {
              ProgressView()
            } else {
              Text("Say Hi")
            }
          }
          .buttonStyle(.bordered)
          
          if !aiResponse.isEmpty {
            Text(aiResponse)
          }
        }
      )
      .tint(.pink)
      
      // MARK: Whisper Ai Example
      // audio recording is not the part of the package, but for the demo to work, we included a quick mockup of the approach.
      #warning("Props for Audio recording approach to Kavasoft: https://www.youtube.com/watch?v=JQ1370Lw99c")
      GroupBox(
        label: Text("Whisper Ai"),
        content: {
          HStack {
            Button {
              UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
              AudioServicesPlaySystemSound(1306)
              Task {
                isLoadingWhisper = true
                let res = try? await OpenAPI.whisperAi(withToken: "<YOUR-API-KEY>", named: "test")
                let whisperResponseMessage = res?.text ?? "⚠️"
                print(whisperResponseMessage)
                whisperResponse = whisperResponseMessage
                isLoadingWhisper = false
              }
            } label: {
              if isLoadingWhisper {
                ProgressView()
              } else {
                Text("Upload Audio")
              }
            }
            .padding()
            .buttonStyle(.bordered)
            
            Button {
              UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
              AudioServicesPlaySystemSound(1306)
              do {
                if isRecording{
                  recorder.stop()
                  isRecording.toggle()
                  return
                }
                
                let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileName = url.appendingPathComponent("test.m4a")
                
                let settings = [
                  AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                  AVSampleRateKey : 12000,
                  AVNumberOfChannelsKey : 1,
                  AVEncoderAudioQualityKey : AVAudioQuality.medium.rawValue
                ]
                
                recorder = try AVAudioRecorder(url: fileName, settings: settings)
                recorder.prepareToRecord()
                recorder.record()
                isRecording.toggle()
              } catch {
                print(error.localizedDescription)
              }
            } label: {
              HStack {
                Image(systemName: "circle.fill")
                  .foregroundColor(isRecording ? .red: .accentColor)
                Text("Record")
              }
            }
            .buttonStyle(.bordered)
          }
          
          if !whisperResponse.isEmpty {
            Text(whisperResponse)
          }
        }
      )
      .tint(.purple)
    }
    .padding(40)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
