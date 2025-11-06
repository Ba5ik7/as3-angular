package app.viewmodels {
  import app.services.TodoService;
  import app.models.Todo;
  import mx.collections.ArrayCollection;
  import mx.events.PropertyChangeEvent;
  import flash.events.EventDispatcher;

  [Bindable]
  public class TodoViewModel extends EventDispatcher {
    [Inject] public var todoService:TodoService;

    private var _todos:ArrayCollection = new ArrayCollection();
    public function get todos():ArrayCollection { return _todos; }
    public function set todos(v:ArrayCollection):void {
      if (_todos == v) return;
      var old:ArrayCollection = _todos;
      _todos = v;
      dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "todos", old, _todos));
      updateStats();
    }

    private var _newTodoText:String = "";
    public function get newTodoText():String { return _newTodoText; }
    public function set newTodoText(v:String):void {
      if (_newTodoText == v) return;
      var old:String = _newTodoText;
      _newTodoText = v;
      dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "newTodoText", old, _newTodoText));
    }

    private var _busy:Boolean = false;
    public function get busy():Boolean { return _busy; }
    public function set busy(v:Boolean):void {
      if (_busy == v) return;
      var old:Boolean = _busy;
      _busy = v;
      dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "busy", old, _busy));
    }

    private var _totalCount:int = 0;
    public function get totalCount():int { return _totalCount; }
    public function set totalCount(v:int):void {
      if (_totalCount == v) return;
      var old:int = _totalCount;
      _totalCount = v;
      dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "totalCount", old, _totalCount));
    }

    private var _activeCount:int = 0;
    public function get activeCount():int { return _activeCount; }
    public function set activeCount(v:int):void {
      if (_activeCount == v) return;
      var old:int = _activeCount;
      _activeCount = v;
      dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "activeCount", old, _activeCount));
    }

    private var _completedCount:int = 0;
    public function get completedCount():int { return _completedCount; }
    public function set completedCount(v:int):void {
      if (_completedCount == v) return;
      var old:int = _completedCount;
      _completedCount = v;
      dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "completedCount", old, _completedCount));
    }

    [PostConstruct]
    public function init():void {
      loadTodos();
    }

    public function loadTodos():void {
      busy = true;
      todoService.getTodos(function(items:Vector.<Todo>):void {
        var arr:Array = [];
        for each (var todo:Todo in items) {
          arr.push(todo);
        }
        todos.source = arr;
        todos.refresh();
        busy = false;
      });
    }

    public function addTodo():void {
      if (!newTodoText || newTodoText.replace(/\s/g, "") == "") return;
      if (busy) return;

      var title:String = newTodoText;
      newTodoText = "";

      var newTodo:Todo = todoService.addTodo(title);
      todos.addItem(newTodo);
      updateStats();
    }

    public function toggleTodo(todo:Todo):void {
      if (busy) return;
      busy = true;

      todoService.toggleTodo(todo.id, function(success:Boolean):void {
        if (success) {
          todo.completed = !todo.completed;
          todos.itemUpdated(todo);
          updateStats();
        }
        busy = false;
      });
    }

    public function removeTodo(todo:Todo):void {
      if (busy) return;
      busy = true;

      todoService.removeTodo(todo.id, function(success:Boolean):void {
        if (success) {
          var index:int = todos.getItemIndex(todo);
          if (index >= 0) {
            todos.removeItemAt(index);
            updateStats();
          }
        }
        busy = false;
      });
    }

    public function clearCompleted():void {
      if (busy || completedCount == 0) return;
      busy = true;

      todoService.clearCompleted(function(success:Boolean):void {
        if (success) {
          loadTodos();
        } else {
          busy = false;
        }
      });
    }

    private function updateStats():void {
      totalCount = todos.length;
      var active:int = 0;
      var completed:int = 0;

      for each (var todo:Todo in todos) {
        if (todo.completed) {
          completed++;
        } else {
          active++;
        }
      }

      activeCount = active;
      completedCount = completed;
    }
  }
}
