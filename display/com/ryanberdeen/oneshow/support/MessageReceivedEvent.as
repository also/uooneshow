package com.ryanberdeen.oneshow.support {
  import flash.events.Event;

  public class MessageReceivedEvent extends Event {
    public static const TYPE:String = 'messageReceived';
    private var _message:Object;
    public function MessageReceivedEvent(message:Object) {
      super(TYPE);
      _message = message;
    }

    public function get message():Object {
      return _message;
    }
  }
}
