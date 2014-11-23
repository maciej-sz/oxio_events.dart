import 'dart:async';
import 'package:unittest/unittest.dart';
import 'package:oxio_events/events.dart';

class FooForm {

  String _code;

  EventResource<String> _beforeSetCodeEr = new EventResource<String>();
//  EventDelegate<String> get onBeforeSetCode => _beforeSetCodeEr.delegate;

  EventResource<String> _afterSetCodeEr = new EventResource<String>();
//  EventDelegate<String> get onAfterSetCode => _afterSetCodeEr.delegate;

  BeforeAfterEventResource<String> _setCodeEventRes = new BeforeAfterEventResource<String>();
  EventDelegate<String> get onBeforeSetCode => _setCodeEventRes.before.delegate;
  EventDelegate<String> get onAfterSetCode => _setCodeEventRes.after.delegate;

  set code(String val) {
    var event = new Event<String>(val);
    _beforeSetCodeEr.fire(event);
    _code = val;
    if (event.isStopped) {
      return;
    }
    _afterSetCodeEr.fire(event);
  }

  set codeAlt(String val) {
    _setCodeEventRes.wrap((){
      _code = val;
    }).run(new Event(val));
  }
  set codeAlt2(String val) {
    new EventChain()
      ..chain(_beforeSetCodeEr.fire)
      ..chain((){ _code = val; })
      ..chain(_afterSetCodeEr.fire)
      ..fire(new Event<String>(val))
    ;
  }

}

class FutureForm {
  String _code;

  Completer<String> _beforeSetCodeCompleter = new Completer<String>();
  Completer<String> _afterSetCodeCompleter = new Completer<String>();

  Future<String> get onBeforeSetCode => _beforeSetCodeCompleter.future;
  Future<String> get onAfterSetCode => _afterSetCodeCompleter.future;

  set code(String val) {
    _beforeSetCodeCompleter.complete(val);
    _code = val;
    _afterSetCodeCompleter.complete(val);
  }
}

void main(){

}