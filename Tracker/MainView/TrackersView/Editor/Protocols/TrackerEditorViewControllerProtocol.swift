import UIKit

protocol TrackerEditorViewControllerProtocol: AnyObject {
    func updateSchedule(from newValues: [WeekDay])
}
