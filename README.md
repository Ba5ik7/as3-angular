# as3-angular

A modern architectural experiment bringing **Angular-like MVVM + Dependency Injection** patterns into **ActionScript 3** using **Flex (Spark) MXML views**.

This project demonstrates:

- **MVVM (Model-View-ViewModel)** separation
- **Bindable state + event-driven UI updates**
- **Dependency Injection** via metadata (`[Inject]`, optional `[PostConstruct]`)
- **Service layer abstraction**
- **MXML components as Views** (Spark `Group`/`SkinnableContainer`)
- **ViewModels as pure ActionScript classes** (no UI dependencies)

---

## Project Structure

```
src/
  Main.mxml                     ← Application shell
  app/core/
    Injector.as                 ← Minimal DI container (reflection-based)
    AppContext.as               ← Bootstraps DI + root view
  app/services/
    CounterService.as           ← Example async service
  app/viewmodels/
    CounterViewModel.as         ← ViewModel containing UI state + actions
  app/views/
    CounterView.mxml            ← MXML UI bound to the ViewModel
```

---

## Key Concepts

### View (MXML)
Defines the user interface and binds to ViewModel properties:

```xml
<s:Label text="Count: {viewModel.count}" />
<s:Button label="Increment" click="viewModel.increment()" />
```

### ViewModel (AS3)
Holds state + UI actions, exposes `[Bindable]` properties:

```as3
[Bindable]
public class CounterViewModel extends EventDispatcher {
  [Inject] public var counterService:CounterService;
  public var count:int = 0;

  public function increment():void {
    counterService.increment(count, function(next:int):void {
      count = next;
    });
  }
}
```

### Service Layer
Logic, networking, timers, external data, etc.

```as3
public function increment(value:int, done:Function):void {
  done(value + 1);
}
```

### Dependency Injection
Handled automatically via metadata + reflection:

```as3
[Inject] public var counterService:CounterService;
```

> **Compiler Flag Required**

Add this to your compiler arguments:

```
-keep-as3-metadata+=Inject,PostConstruct
```

---

## Running the Project

1. Open in **Flash Builder 4.x** or VSCode + Flex SDK.
2. Ensure you're using **Flex 4.6 SDK** (Spark).
3. Run as a **Web SWF** or **AIR Desktop app**.

Command line example:

```
mxmlc src/Main.mxml -keep-as3-metadata+=Inject,PostConstruct
```

---

## Why This Exists

This project is for developers who:

- Prefer **MVVM** over older AS3 frameworks like Robotlegs / PureMVC.
- Want clean separation between UI and logic.
- Like Angular patterns and want them in AS3.

---

## Future Ideas

- Router-like navigation
- Signals / Observables (Rx-inspired)
- View transition animations
- Component library & templates

---

## License

MIT
