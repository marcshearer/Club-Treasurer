import SwiftUI

@main struct ClubTreasurerApp : App {
    public let context = PersistenceController.shared.container.viewContext
    
    init() {
        CoreData.context = context
        
        MyApp.shared.start()
    }
    
    var body: some Scene {
        MyScene()
    }
}

struct MyScene: Scene {
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
                SelectInputView()
                    .navigationTitle("Club Treasurer")
                    .frame(minWidth: 500, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
        }
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .onChange(of: scenePhase, initial: false) { (_, phase) in
            if phase == .active {
                
            }
        }
    }
}
 
struct SelectInputView : View {
    
    var body: some View {
        VStack {
            Banner(title: Binding.constant("Club Treasurer"), back: false)
            Text("Hello World")
                .frame(width: 500, height: 500)
            Spacer()
        }
    }
}

