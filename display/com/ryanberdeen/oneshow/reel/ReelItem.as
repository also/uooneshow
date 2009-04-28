package com.ryanberdeen.oneshow.reel {
  interface ReelItem {
    function start():void;
    function stop():void;
    //function get isTimed():Boolean;
    function get nominalTime():int;
    function get loadTime():int;
  }
}
