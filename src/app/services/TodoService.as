package app.services {
  import app.models.Todo;
  import flash.events.TimerEvent;
  import flash.utils.Timer;

  public class TodoService {
    private var nextId:int = 1;
    private var todos:Vector.<Todo> = new Vector.<Todo>();

    public function TodoService() {
      // Initialize with some sample todos
      addTodo("Learn ActionScript 3", true);
      addTodo("Build MVVM architecture", true);
      addTodo("Create Todo app", false);
    }

    public function getTodos(callback:Function):void {
      // Simulate async operation
      var t:Timer = new Timer(50, 1);
      t.addEventListener(TimerEvent.TIMER_COMPLETE, function(_:TimerEvent):void {
        // Return a copy to prevent external mutations
        var copy:Vector.<Todo> = new Vector.<Todo>();
        for each (var todo:Todo in todos) {
          copy.push(new Todo(todo.id, todo.title, todo.completed));
        }
        callback(copy);
      });
      t.start();
    }

    public function addTodo(title:String, completed:Boolean = false):Todo {
      var todo:Todo = new Todo(nextId++, title, completed);
      todos.push(todo);
      return todo;
    }

    public function toggleTodo(id:int, callback:Function):void {
      var t:Timer = new Timer(50, 1);
      t.addEventListener(TimerEvent.TIMER_COMPLETE, function(_:TimerEvent):void {
        for each (var todo:Todo in todos) {
          if (todo.id == id) {
            todo.completed = !todo.completed;
            callback(true);
            return;
          }
        }
        callback(false);
      });
      t.start();
    }

    public function removeTodo(id:int, callback:Function):void {
      var t:Timer = new Timer(50, 1);
      t.addEventListener(TimerEvent.TIMER_COMPLETE, function(_:TimerEvent):void {
        for (var i:int = 0; i < todos.length; i++) {
          if (todos[i].id == id) {
            todos.splice(i, 1);
            callback(true);
            return;
          }
        }
        callback(false);
      });
      t.start();
    }

    public function clearCompleted(callback:Function):void {
      var t:Timer = new Timer(50, 1);
      t.addEventListener(TimerEvent.TIMER_COMPLETE, function(_:TimerEvent):void {
        var newTodos:Vector.<Todo> = new Vector.<Todo>();
        for each (var todo:Todo in todos) {
          if (!todo.completed) {
            newTodos.push(todo);
          }
        }
        todos = newTodos;
        callback(true);
      });
      t.start();
    }
  }
}
