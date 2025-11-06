package app.models {
  public class Todo {
    public var id:int;
    public var title:String;
    public var completed:Boolean;

    public function Todo(id:int, title:String, completed:Boolean = false) {
      this.id = id;
      this.title = title;
      this.completed = completed;
    }
  }
}
