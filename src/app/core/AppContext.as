package app.core {
  import app.services.CounterService;
  import app.viewmodels.CounterViewModel;
  import app.views.CounterView;
  import mx.core.UIComponent;
  import mx.core.IVisualElement;
  import mx.core.IVisualElementContainer;
  import flash.display.DisplayObjectContainer;

  public class AppContext {
    public var injector:Injector;

    public function AppContext(root:UIComponent) {
      injector = new Injector();
      // Map Services & ViewModels
      injector.mapClass(CounterService);
      injector.mapClass(CounterViewModel);

      // Create View + ViewModel and inject
      const vm:CounterViewModel = injector.getInstance(CounterViewModel);
      injector.injectInto(vm);

      const view:CounterView = new CounterView();
      view.viewModel = vm;         // pass VM into MXML view
      injector.injectInto(view);   // (optional) if views need services

      // Spark containers (Application/Group/SkinnableContainer) require addElement()
      if (root is IVisualElementContainer) {
        IVisualElementContainer(root).addElement(view as IVisualElement);
      } else if (root is DisplayObjectContainer) {
        // Fallback for pure DisplayList containers
        DisplayObjectContainer(root).addChild(view);
      } else {
        throw new Error("AppContext: unsupported root container for adding view");
      }
    }
  }
}
