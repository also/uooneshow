package {
  import flash.events.DataEvent;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.SecurityErrorEvent;
  import flash.net.XMLSocket;

  public class Connector {
    private var socket:XMLSocket;

    public function connect(hostname:String, port:Number):void {
      socket = new XMLSocket();
      socket.addEventListener(Event.CONNECT, onSocketConnect);
      socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketSecurityError);
      socket.addEventListener(DataEvent.DATA, onSocketData);
      socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketIoError);
      socket.addEventListener(Event.CLOSE, onSocketClose);

      socket.connect(hostname, port);
    }

    public function send(data:String):void {
      socket.send(data);
    }

    public function close():void {
      socket.close();
    }

    private function onSocketConnect(event:Event):void {
      this.send('hi');
      this.send('server listen test');
      this.send('hello world');
      doCallback('onSocketConnect');
    }

    private function onSocketSecurityError(event:SecurityErrorEvent):void {
      doCallback('onSocketSecurityError');
    }

    private function onSocketData(event:DataEvent):void {
      trace('received: ' + event.data);
    }

    private function onSocketIoError(event:IOErrorEvent):void {
      doCallback('onSocketIoError');
    }

    // NOTE: only called when the server closes the connection
    private function onSocketClose(event:Event):void {
      doCallback('onSocketClose');
    }

    private function doCallback(callback:String):void {
      trace('callback: ' + callback);
    }
  }
}