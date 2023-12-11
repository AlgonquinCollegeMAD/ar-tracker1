import SwiftUI

@main
struct Tracker_1_App: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

struct ContentView: View {
  @StateObject var viewModel = FaceTrackingViewModel()
  
  var body: some View {
    ZStack{
      VStack {
        ARFaceTrackingView(viewModel: viewModel)
        Text("Action: \(viewModel.action)")
          .padding()
      }
      VStack(alignment: .leading) {
        switch viewModel.action {
        case "Are you flirting?": Text("😍").font(Font.system(size: 100))
        case "Your cheeks are puffed.": Text("☺️").font(Font.system(size: 100))
        case "Don't stick your tongue out!": Text("😜").font(Font.system(size: 100))
        case "You are weird!": Text("🤓").font(Font.system(size: 100))
        default: Text("🧐").font(Font.system(size: 100))
        }
        Spacer()
      }
    }
  }
}
