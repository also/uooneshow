package com.ryanberdeen.oneshow.support {
  import com.adobe.serialization.json.JSON;

  import flash.events.Event;
  import flash.net.URLLoader;
  import flash.net.URLRequest;

  public class JsonLoader {
    private var loader:URLLoader;
    private var url:String;
    private var resultHandler:Function;

    public function JsonLoader(url:String, resultHandler:Function) {
      this.url = url;
      this.resultHandler = resultHandler;
      loader = new URLLoader();
      loader.addEventListener(Event.COMPLETE, completeHandler);
    }

    public function load() {
      var request:URLRequest = new URLRequest(url);
      loader.load(request);
    }

    public function completeHandler(e:Event):void {
      var result:Object = JSON.decode(loader.data);
      resultHandler(result);
    }
  }
}
