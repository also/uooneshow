package {
  import com.adobe.serialization.json.JSON;

  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.TimerEvent;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.utils.Timer;

  class Monitor extends EventDispatcher {
    private var loader:URLLoader;
    private var maxId:String;

    private var messagesUrl:String;
    private var timer:Timer;

    public function Monitor(interval:int) {
      // TODO show error if messages url is null
      messagesUrl = Main.baseUrl +  'messages.json';
      maxId = "0";
      loader = new URLLoader();
      loader.addEventListener(Event.COMPLETE, onComplete);

      timer = new Timer(interval);
      timer.addEventListener('timer', timerHandler);
    }

    public function start():void {
      update();
      timer.start();
    }

    private function timerHandler(e:TimerEvent):void {
      update();
    }

    private function update():void {
      var request:URLRequest = new URLRequest(messagesUrl + '?since_id=' + maxId);
      loader.load(request);
    }

    private function onComplete(event:Event):void {
      var result:Object = JSON.decode(loader.data);
      var messages:Array = result.messages;
      maxId = result.max_id;

      for each (var message in messages) {
        var e:MessageReceivedEvent = new MessageReceivedEvent(message);
        dispatchEvent(e);
      }
    }
  }
}
