package {
  import com.adobe.serialization.json.JSON;

  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.net.URLLoader;
  import flash.net.URLRequest;

  class Monitor extends EventDispatcher {
    private var loader:URLLoader;
    private var lastId:String;

    private var messagesUrl:String;

    public function Monitor(animation:Main) {
      // TODO show error if messages url is null
      messagesUrl = Main.baseUrl +  'messages.json';
      lastId = "0";
      loader = new URLLoader();
      loader.addEventListener(Event.COMPLETE, onComplete);
    }

    public function update():void {
      var request:URLRequest = new URLRequest(messagesUrl);
      loader.load(request);
    }

    private function onComplete(event:Event):void {
      var messages:Array = JSON.decode(loader.data);

      for each (var message in messages) {
        var e:MessageReceivedEvent = new MessageReceivedEvent(message);
        dispatchEvent(e);
      }
    }
  }
}
