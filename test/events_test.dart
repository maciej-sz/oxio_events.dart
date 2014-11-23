import 'package:unittest/unittest.dart';
import 'package:oxio_events/events.dart';

class FooForm {

  EventResource<int> _setCodeEventResource = new EventResource<int>();
  EventDelegate<int> get onSetCode => _setCodeEventResource.delegate;

  void setCode() {

  }

}

void main() {

  group('Events base', (){

    test('getting delegate', (){
      var evt = new Event<String>();
      expect(evt.delegate is EventDelegate, isTrue);
    });

  });

  group('events', (){

    test('base', (){

      var evt = new Event<int>();

      evt.delegate.listen((EventArgs<int> args) {
        print(args.data);
      });

    });

  });

  group('eventScopes', (){
    test('multiple', (){

      var form = new EditUserForm();

      form.onDblClick.bind((){
        var pickAvatarWin = new PickAvaterWindow();
        pickAvatarWin.onSubmit.bind((Event<dynamic> evt){
          form.addData(evt.data);
        });
        pickAvatarWin.show();
      });

      form.onBeforeAddData.bind((Event<dynamic> evt){
        if ( '' == evt.data.name ) {
          print('err: name cannot be empty');
          evt.stop();
        }
      });

      form.onSetCode.bind((Event<String> evt){
        if ( '' == evt.data ) {
          print('err: code cannot be empty');
          evt.stop();
        }
      });

    });
  });
}



//foo.