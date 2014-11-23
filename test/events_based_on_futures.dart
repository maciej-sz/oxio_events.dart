import 'dart:async';

void main(){

  var clickCompleter = new Completer<String>();

  var onClickFuture = clickCompleter.future;
  onClickFuture.then((String arg){
    print("1. $arg");
  });
  onClickFuture.then((String arg){
    print("2. $arg");
  });

  clickCompleter.complete("test");
  clickCompleter.complete("test2");

}