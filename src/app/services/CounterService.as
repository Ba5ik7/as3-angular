package app.services {
  import flash.events.TimerEvent;
  import flash.utils.Timer;

  public class CounterService {
    public function increment(value:int, done:Function):void {
      // pretend async; call `done(newValue:int)` later
      var t:Timer = new Timer(100, 1);
      t.addEventListener(TimerEvent.TIMER_COMPLETE, function(_:TimerEvent):void {
        done(value + 1);
      });
      t.start();
    }
  }
}
