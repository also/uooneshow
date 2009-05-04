package com.ryanberdeen.oneshow.reel {
  import com.ryanberdeen.oneshow.Main;

  import flash.display.Bitmap;
  import flash.display.DisplayObject;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.display.Loader;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.net.URLRequest;
  import flash.text.TextField;
  import flash.text.TextFormat;

  class FeaturedImageSprite extends Sprite implements ReelItem {
    private var controller:ReelController;
    private var displayWidth:int;
    private var displayHeight:int;
    private var credit:FeaturedItemCreditSprite;

    private var imageLoader:Loader;

    public function FeaturedImageSprite(image:Object, controller:ReelController, displayWidth:int, displayHeight:int) {
      this.controller = controller;
      this.displayWidth = displayWidth;
      this.displayHeight = displayHeight;
      imageLoader = new Loader();
      imageLoader.load(new URLRequest(Main.resolveUrl(image.media_url)));
      imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
      imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
      addChild(imageLoader);

      credit = new FeaturedItemCreditSprite(image);
      credit.alpha = 0.5;
      credit.y = displayHeight - credit.height;
      addChild(credit);
    }

    public function start():void {
      // nothing to do
    }

    public function get isTimed():Boolean {
      return false;
    }

    public function get nominalTime():int {
      return 10000;
    }

    public function get loadTime():int {
      return 5000;
    }

    public function stop():void {
      // nothing to do
    }

    public function pause():void {
      // nothing to do
    }

    public function resume():void {
      // nothing to do
    }

    private function completeHandler(event:Event):void {
      var image:DisplayObject = imageLoader.content;
      Bitmap(image).smoothing = true;
      if (image.width > displayWidth) {
        image.width = displayWidth;
      }
      if (image.height > displayHeight) {
        image.height = displayHeight;
      }
      image.scaleY = image.scaleX = Math.min(image.scaleY, image.scaleX);

      image.x = (displayWidth - image.width) / 2;
      image.y = (displayHeight - image.height) / 2;

      controller.itemReady();
    }

    private function ioErrorHandler(event:IOErrorEvent):void {
      // TODO
      trace('io error: ' + event.text)
    }
  }
}
