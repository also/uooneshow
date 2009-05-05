package com.ryanberdeen.oneshow.reel {
  import com.ryanberdeen.oneshow.Main;

  import flash.display.Sprite;
  import flash.events.*;
  import flash.media.Video;
  import flash.net.NetConnection;
  import flash.net.NetStream;
  import flash.utils.Timer;

  public class FeaturedVideoSprite extends Sprite implements ReelItem {
    private var displayWidth:int;
    private var displayHeight:int;
    private var controller:ReelController;

    private var videoData:Object;
    private var credit:FeaturedItemCreditSprite;
    private var connection:NetConnection;
    private var stream:NetStream;
    private var video:Video;
    private var buffered:Boolean;
    private var metadataReceived:Boolean;
    private var timer:Timer;
    private var duration:Number;

    public function FeaturedVideoSprite(videoData:Object, controller:ReelController, displayWidth:int, displayHeight:int) {
      this.controller = controller;
      this.displayWidth = displayWidth;
      this.displayHeight = displayHeight;
      this.videoData = videoData;
      connection = new NetConnection();
      connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
      connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
      connection.connect(null);
      buffered = false;
      metadataReceived = false;

      credit = new FeaturedItemCreditSprite(videoData, displayWidth);
      credit.alpha = 0.5;
      credit.y = displayHeight - credit.height;
      addChild(credit);
    }

    public function start():void {
      stream.resume();
    }

    public function stop():void {
      stream.close();
      timer.stop();
    }

    public function pause():void {
      stream.pause();
    }

    public function resume():void {
      stream.resume();
    }

    public function get isTimed():Boolean {
      return true;
    }

    public function get nominalTime():int {
      return duration;
    }

    public function get loadTime():int {
      return 10000;
    }

    private function timerHandler(e:Event):void {
      // TODO

      var buffered:Boolean = stream.bufferLength >= stream.bufferTime;

      if (stream.bytesLoaded == stream.bytesTotal) {
        buffered = true;
        timer.stop();
      }

      if (buffered) {
        if (!this.buffered && metadataReceived) {
          controller.itemReady();
        }
        this.buffered = true;
      }
    }

    private function netStatusHandler(event:NetStatusEvent):void {
      trace(event.info.code);
      switch (event.info.code) {
        case 'NetConnection.Connect.Success':
          connectStream();
          break;
        case 'NetStream.Play.Start':
          stream.pause();
          break;
        case 'NetStream.Play.Stop':
          controller.itemFinished();
          break;
        case 'NetStream.Play.StreamNotFound':
          // TODO
          trace("Unable to locate video: " + videoData.media_url);
          break;
      }
    }

    private function connectStream():void {
      stream = new NetStream(connection);
      // TODO configurable
      stream.bufferTime = 30;
      stream.client = this;
      // TODO listen for io errors?
      stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
      stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
      video = new Video();
      video.smoothing = true;
      video.attachNetStream(stream);
      stream.play(Main.resolveUrl(videoData.media_url));
      addChild(video);

      // TODO
      timer = new Timer(500);
      timer.addEventListener('timer', timerHandler);
      timer.start();
    }

    private function securityErrorHandler(event:SecurityErrorEvent):void {
      // TODO
      trace("securityErrorHandler: " + event);
    }

    private function asyncErrorHandler(event:AsyncErrorEvent):void {
      // ignore AsyncErrorEvent events. this is important.
    }

    public function onMetaData(metadata:Object):void {
      if (!metadataReceived) {
        // TODO dimensions
        var scale = Math.min(displayWidth / metadata.width, displayHeight / metadata.height);

        if (scale < 1) {
          video.width = metadata.width * scale;
          video.height = metadata.height * scale;
        }

        video.x = (displayWidth - video.width) / 2;
        video.y = (displayHeight - video.height) / 2;
        if (buffered) {
          controller.itemReady();
        }
      }

      this.duration = metadata.duration * 1000 + 3000;
      metadataReceived = true;
    }
  }
}
