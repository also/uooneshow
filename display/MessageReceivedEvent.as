package {
  import flash.events.Event;

  class MessageReceivedEvent extends Event {
    public static const TYPE:String = 'messageReceived';
    private var _message:Object;
    public function MessageReceivedEvent(message:Object) {
      super(TYPE);
      _message = message;
    }

    public function get message() {
      return _message;
    }
  }
}
