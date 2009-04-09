package {
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.text.TextField;
  import flash.text.TextFormat;

  class Message extends Sprite {
    private var text:TextField;

    public function Message(string:String, textFormat:TextFormat) {
      text = new TextField();
      text.defaultTextFormat = textFormat;
      text.text = string;
      text.width = 630;
      text.wordWrap = true;
      addChild(text);
      addEventListener(Event.ADDED_TO_STAGE, addedToStage);
    }

    private function addedToStage(e:Event):void {
    }

    public function get textHeight():Number {
      return text.textHeight;
    }
  }
}