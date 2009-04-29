package com.ryanberdeen.oneshow.support {
  import flash.events.Event;

  public class ItemsReceivedEvent extends Event {
    public static const TYPE:String = 'itemsReceived';
    private var _items:Array;
    private var _newItems:Array;

    public function ItemsReceivedEvent(items:Array, newItems:Array) {
      super(TYPE);
      _items = items;
      _newItems = newItems;
    }

    public function get items():Array {
      return _items;
    }

    public function get newItems():Array {
      return _newItems;
    }
  }
}
