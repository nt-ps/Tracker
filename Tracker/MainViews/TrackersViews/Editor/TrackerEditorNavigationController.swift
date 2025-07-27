import UIKit

final class TrackerEditorNavigationController: UINavigationController {
    
    // weak var trackersNavigationItem: TrackersNavigationItem?
    var trackersSource: TrackersSourceProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        
        // Формирую общие Model и ViewModel для всего редактора
        // как если бы он был одноэкранным, где все параметры идут
        // одной лентой, без лишнего функционала - только установка и
        // валидация значений.
        let trackerEditorModel = TrackerEditorModel()
        let trackerEditorViewModel = TrackerEditorViewModel(
            for: trackerEditorModel,
            with: trackersSource ?? TrackerStore()
        )
        
        let typeEditorViewController = TypeEditorViewController()
        
        // Для всех подвью редактора создаю свои ViewModel как бы над
        // (или вытекающим из) TrackerEditorViewModel. Благодаря этому
        // TrackerEditorModel не будет торчать там, где не нужно (для передачи
        // от одной VM к другой при переключениях между экранами она должна
        // где-то торчать, и по-моему это не гуд), и можно не забивать логику
        // TrackerEditorViewModel функциналом, который не касается непосредственно
        // редактирования трекера (например, это создание/редактирование категорий,
        // закрытие вью при установке значения и т.д.).
        let typeEditorViewModel = TypeEditorViewModel(
            from: trackerEditorViewModel
        )
        typeEditorViewController.setViewModel(typeEditorViewModel)
        
        // TODO: Возможно, после перехода на MVVM это поле можно будет убрать.
        // typeEditorViewController.trackersNavigationItem = trackersNavigationItem
        
        viewControllers = [ typeEditorViewController ]
    }
}
