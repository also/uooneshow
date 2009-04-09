package {
  import flash.net.*;
  import flash.events.Event;

  class Monitor {
    private var loader:URLLoader;
    private var animation:Main;
    private var lastId:String;

    public function Monitor(animation:Main) {
      this.animation = animation;
      lastId = "0";
      loader = new URLLoader();
      loader.addEventListener(Event.COMPLETE, onComplete);
    }

    public function update():void {
      var request:URLRequest = new URLRequest('http://weareslam.com/live/next/' + lastId);
      loader.load(request);
    }

    private function onComplete(event:Event):void {
      var lines:Array = loader.data.split('\n');
      var command:String = lines.shift();
      lastId = lines.shift();
      for each (var line in lines) {
        animation.addMessage(line);
      }
    }
  }
}