package app.viewmodels {
  import app.services.CounterService;
  import mx.events.PropertyChangeEvent;
  import mx.events.PropertyChangeEventKind;
  import flash.events.EventDispatcher;

  [Bindable] // auto propertyChange if using setters w/ dispatch
  public class CounterViewModel extends EventDispatcher {
    [Inject] public var counterService:CounterService;

    private var _count:int = 0;
    public function get count():int { return _count; }
    public function set count(v:int):void {
      if (_count == v) return;
      var old:int = _count;
      _count = v;
      dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "count", old, _count));
    }

    private var _busy:Boolean = false;
    public function get busy():Boolean { return _busy; }
    public function set busy(v:Boolean):void {
      if (_busy == v) return;
      var old:Boolean = _busy;
      _busy = v;
      dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "busy", old, _busy));
    }

    // Command: Increment (delegates to service)
    public function increment():void {
      if (busy) return;
      busy = true;
      counterService.increment(count, function(next:int):void {
        count = next;
        busy = false;
      });
    }

    // Command: Reset
    public function reset():void { count = 0; }
  }
}
