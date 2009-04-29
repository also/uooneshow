package com.ryanberdeen.oneshow.support {
  import com.ryanberdeen.oneshow.Main;

  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.TimerEvent;
  import flash.utils.Timer;

  public class Monitor extends EventDispatcher {
    private var url:String;
    private var property:String;
    private var loader:JsonLoader;
    private var maxId:String;

    private var messagesUrl:String;
    private var timer:Timer;
    private var _items:Array;

    public function Monitor(url:String, property:String, interval:int) {
      this.url = url;
      this.property = property;
      maxId = '0';
      loader = new JsonLoader(null, onComplete);

      timer = new Timer(interval);
      timer.addEventListener('timer', timerHandler);

      _items = [];
    }

    public function get items():Array {
      return _items;
    }

    public function start():void {
      update();
      timer.start();
    }

    public function stop():void {
      timer.stop();
    }

    private function timerHandler(e:TimerEvent):void {
      update();
    }

    private function update():void {
      loader.url = url + '?since_id=' + maxId;
      loader.load();
    }

    private function onComplete(result:Object):void {
      var newItems:Array = result[property];
      maxId = result.max_id;
      if (newItems.length > 0) {
        _items = _items.concat(newItems);
        maxId = result.max_id;

        dispatchEvent(new ItemsReceivedEvent(_items, newItems));
      }
    }
  }
}
