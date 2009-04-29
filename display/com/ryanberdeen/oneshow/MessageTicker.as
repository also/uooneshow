package com.ryanberdeen.oneshow {
  import com.ryanberdeen.oneshow.support.ItemsReceivedEvent;

  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.Rectangle;
  import flash.text.TextField;
  import flash.text.TextFormat;

  class MessageTicker extends Sprite {
    private static const SPACING:int = 30;
    private var messageX:int;
    private var textFormat:TextFormat;

    public function MessageTicker() {
      cacheAsBitmap = true;

      textFormat = new TextFormat();
      textFormat.font = 'Helvetica';
      textFormat.size = 36;
      textFormat.color = 0xFFFFFF;

      addEventListener(Event.ADDED_TO_STAGE, addedToStage);
      addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function addedToStage(e:Event):void {
      reset();
    }

    public function reset():void {
      scrollRect = new Rectangle(-stage.stageWidth, 0, stage.stageWidth, stage.stageHeight);
      messageX = 0;
    }

    public function itemsReceived(itemsEvent:ItemsReceivedEvent):void {
      for each(var item:Object in itemsEvent.newItems) {
        addItem(item);
      }
    }

    private function addItem(item:Object):void {
      var text:TextField = new TextField();
      text.defaultTextFormat = textFormat;
      text.text = item.text;
      text.width = text.textWidth + 5;
      text.x = messageX;
      messageX += text.width + SPACING;
      addChild(text);
    }

    private function onEnterFrame(e:Event):void {
      var rect:Rectangle = scrollRect;
      rect.x += 3;
      if (rect.x > messageX) {
        rect.x = -stage.stageWidth;
      }
      scrollRect = rect;
    }
  }
}
