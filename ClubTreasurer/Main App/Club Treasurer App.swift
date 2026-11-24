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
                RootView()
#if os(macOS)
                .background(WindowSetup())
#endif
                .buttonStyle(.plain)
                .frame(minWidth: 600, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
        }
        //.windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
        .onChange(of: scenePhase, initial: false) { (_, phase) in
            if phase == .active {
                
            }
        }
    }
}

#if os(macOS)
import SwiftUI
import AppKit

struct WindowSetup: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            guard let window = view.window else { return }

            // 1. Keep normal traffic lights, hide the title bar strip
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.styleMask.insert(.fullSizeContentView)

            // 2. Make the green button "Zoom" (fill visibleFrame) instead of entering Full Screen
            window.collectionBehavior.remove(.fullScreenPrimary)
            window.collectionBehavior.insert(.fullScreenNone)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
#endif
