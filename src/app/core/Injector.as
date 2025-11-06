package app.core {
  import flash.utils.Dictionary;
  import flash.utils.describeType;
  import flash.utils.getDefinitionByName;

  public class Injector {
    private var mappings:Dictionary = new Dictionary(); // Class -> provider

    public function mapClass(type:Class, to:Class = null):Injector {
      mappings[type] = { kind: "class", to: to || type, instance: null };
      return this;
    }

    public function mapValue(type:Class, value:*):Injector {
      mappings[type] = { kind: "value", instance: value };
      return this;
    }

    public function getInstance(type:Class):* {
      var rec:Object = mappings[type];
      if (!rec) throw new Error("No mapping for " + type);
      if (rec.kind == "value") return rec.instance;
      if (!rec.instance) {
        rec.instance = new (rec.to as Class)();
      }
      return rec.instance;
    }


    public function injectInto(target:*):void {
      const xml:XML = describeType(target);

      // public vars + writable accessors
      const members:XMLList =
          xml..variable + xml..accessor.(@access=="readwrite" || @access=="writeonly");

      for each (var node:XML in members) {
        // safer than `metadata`: avoids the #1065
        const hasInject:Boolean = node.child("metadata").(@name=="Inject").length() > 0;
        if (!hasInject) continue;

        const prop:String = node.@name.toString();
        const typeName:String = node.@type.toString();
        var C:Class;
        try {
          C = getDefinitionByName(typeName) as Class;
        } catch (_:*) { C = null; }
        if (!C) throw new Error("Injector can't resolve type " + typeName + " for " + prop);

        target[prop] = getInstance(C);
      }

      // Optional: @PostConstruct
      for each (var m:XML in xml..method.(child("metadata").(@name=="PostConstruct").length() > 0)) {
        target[m.@name.toString()]();
      }
    }
  }
}
