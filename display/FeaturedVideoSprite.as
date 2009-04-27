package {
  import flash.display.Sprite;
  import flash.events.*;
  import flash.media.Video;
  import flash.net.NetConnection;
  import flash.net.NetStream;
  import flash.utils.Timer;

  public class FeaturedVideoSprite extends Sprite {
    private var videoData:Object;
    private var connection:NetConnection;
    private var stream:NetStream;
    private var video:Video;
    private var timer:Timer;

    public function FeaturedVideoSprite(videoData:Object, displayWidth:int, displayHeight:int) {
      this.videoData = videoData;
      connection = new NetConnection();
      connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
      connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
      connection.connect(null);

      // TODO
      //var timer:Timer = new Timer(1000);
      //timer.addEventListener('timer', timerHandler);
      //timer.start();
    }

    private function timerHandler(e:Event):void {
      // TODO show progress
    }

    private function netStatusHandler(event:NetStatusEvent):void {
      switch (event.info.code) {
        case "NetConnection.Connect.Success":
          connectStream();
          break;
        case "NetStream.Play.StreamNotFound":
          // TODO
          trace("Unable to locate video: " + videoData.video_url);
          break;
      }
    }

    private function connectStream():void {
      stream = new NetStream(connection);
      stream.bufferTime = 10;
      stream.client = this;
      stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
      stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
      video = new Video();
      video.smoothing = true;
      video.attachNetStream(stream);
      stream.play(videoData.video_url);
      addChild(video);
    }

    private function securityErrorHandler(event:SecurityErrorEvent):void {
      // TODO
      trace("securityErrorHandler: " + event);
    }

    private function asyncErrorHandler(event:AsyncErrorEvent):void {
      // ignore AsyncErrorEvent events. this is important.
    }

    public function onMetaData(metadata:Object):void {
      // TODO dimensions
      video.width = metadata.width;
      video.height = metadata.height;
    }
  }
}
