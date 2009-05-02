var logElt = $('log');
var logSentElt = $('log_sent');
var logTimeElt = $('log_time');

var timestamp = function() {
  var d = new Date();
  var h = d.getHours();
  if (h < 10) {
    h = '0' + h;
  }
  var m = d.getMinutes();
  if (m < 10) {
    m = '0' + m;
  }
  var s = d.getSeconds();
  if (s < 10) {
    s = '0' + s;
  }
  return '' + h + ':' + m + ':' + s;
};

var onEvent = function(callback) {
  log('event', callback);
};

var log = function(type, message) {
  if (logTimeElt.checked) {
    logElt.insert(new Element('span', {'class': 'timestamp'}).update(timestamp()));
    logElt.insert(' ');
  }
  logElt.insert(new Element('span', {'class': type}).update(message));
  logElt.insert('\n');
  logElt.scrollTop = logElt.scrollHeight;
}

rjs.swfUrl = '/swfs/rjs.swf';

var send = function(message) {
  if (logSentElt.checked) {
    log('sent', message);
  }

  rjs.send(message);
};

var connect = function() {
  var host = location.hostname;
  onEvent('connecting to ' + location.hostname + ':1843');
  rjs.connect(location.hostname, 1843, {
    onSocketConnect: function(callback) {
      onEvent('connected');
    },

    onEvent: onEvent,

    onReceive: function(data) {
      log('received', data);
    }
  });
};

var disconnect = function() {
  onEvent('disconnecting');
  rjs.disconnect();
};

$('connect').observe('click', function(e) {
  e.stop();
  connect();
});

$('disconnect').observe('click', function(e) {
  e.stop();
  disconnect();
});

$('input_form').observe('submit', function(event) {
  event.stop();
  var value = $('input').value;

  send(value);

  $('input').value = '';
});

$('clear_log').observe('click', function(e) {
  e.stop();
  logElt.update('');
});
