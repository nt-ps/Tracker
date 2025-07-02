import UIKit

protocol ScheduleEditorViewControllerProtocol: AnyObject {
    var trackerEditorView: TrackerEditorViewControllerProtocol? { get set }
    var days: [WeekDay] { get set }
}
