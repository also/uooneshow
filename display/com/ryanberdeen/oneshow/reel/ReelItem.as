package com.ryanberdeen.oneshow.reel {
  interface ReelItem {
    function start():void;
    function stop():void;
    function pause():void;
    function resume():void;
    function get nominalTime():int;
    function get loadTime():int;
  }
}
