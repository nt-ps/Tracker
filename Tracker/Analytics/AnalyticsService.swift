import Foundation
import AppMetricaCore

struct AnalyticsService {
    private init() { }
    
    static func activate() {
        if let configuration = AppMetricaConfiguration(
            apiKey: "e0bcaecd-2fe7-49cd-803c-3d97a2c4ed9c"
        ) {
            AppMetrica.activate(with: configuration)
        }
    }

    static func reportOpening(_ screen: String) {
        AnalyticsService.report(
            event: .open,
            params: [.screen: screen]
        )
    }
    
    static func reportСlosing(_ screen: String) {
        AnalyticsService.report(
            event: .close,
            params: [.screen: screen]
        )
    }
    
    static func reportClick(screen: String, item: String) {
        AnalyticsService.report(
            event: .click,
            params: [
                .screen: screen,
                .item: item
            ]
        )
    }
    
    private static func report(event: AnalyticsEvents, params: [AnalyticsParams : Any]) {
        let paramsString = params.reduce(into: [:]) { (result, item) in
            result[item.key.rawValue] = item.value
        }
        AppMetrica.reportEvent(name: event.rawValue, parameters: paramsString, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
