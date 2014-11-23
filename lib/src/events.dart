part of oxio.events;

class EventResource<T> {

  List<Function> _listeners;
  EventDelegate<T> _delegate;

  EventDelegate<T> get delegate {
    if (null == _delegate) {
      _delegate = new EventDelegate<T>(this);
    }
    return _delegate;
  }

  void addListener(Function listener) => _listeners.add(listener);

  Future fire(Event<T> evt) {
    return new Future((){
      _listeners.forEach((Function listener){
        listener(evt);
      });
    });
  }
}

typedef void Action();

class BeforeAfterEventResource<T> {

  final EventResource<T> _before = new EventResource<T>();
  final EventResource<T> _after = new EventResource<T>();

  EventResource<T> get before => _before;
  EventResource<T> get after => _after;

  BeforeAfterEventResource();

  void wrapRun(Action callback, [Event<T> evt = null]) {
    if ( null == evt ) {
      evt = new Event();
    }
    if ( evt.isStopped ) {
      return;
    }
    _before.fire(evt);
    if ( evt.isStopped ) {
      return;
    }
    callback();
    _after.fire(evt);
  }

}

class Event<T> {
  final T _data;
  bool _isStopped = false;

  Event([T this._data = null]);

  bool get isStopped => _isStopped;
  T get data => _data;

  void stop() {
    _isStopped = true;
  }
}

class EventDelegate<T>{
  EventResource<T> _eventResource;
  EventDelegate(EventResource<T> this._eventResource);
  void listen(Function listener) => _eventResource.addListener(listener);
}