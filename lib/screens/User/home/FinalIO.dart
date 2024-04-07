import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';
import 'package:pusher_client/pusher_client.dart';

class FinalIO extends StatefulWidget {
  const FinalIO({super.key});

  @override
  State<FinalIO> createState() => _FinalIOState();
}

class _FinalIOState extends State<FinalIO> {
  PusherClient? pusher;
  String myEvent = 'hello event';

  @override
  void initState() {
    super.initState();
    pusher = PusherClient(
      'cd3ed25c9be7e1f981d8',
      PusherOptions(
        cluster: 'ap2',
        // host: "https://demokrishi.jaruwa.com",
        // auth: PusherAuth(
        //   'https://demokrishi.jaruwa.com/test',
        //   // headers: {
        //   //   'Authorization':
        //   //       'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiYjY4ZTE2ODZhZWJjMGI2MTM0MTNmODdiYzk2ZTI5Y2UzOGE2ZDhkNjYwZjhhZTgzODI0YmE4MWIwODMzNmYyM2YxY2U3NzJlZDdiZWJlMTMiLCJpYXQiOjE2ODE4OTk0MTQuMzA5MDYzLCJuYmYiOjE2ODE4OTk0MTQuMzA5MDcxLCJleHAiOjE2ODE5ODU4MTQuMjk5MDk1LCJzdWIiOiI1Iiwic2NvcGVzIjpbXX0.X-N9_p9aoN7P-S7U6KAyYLJLGeVLvS8PA7no_o7F2Ks3HCp7-Oi3jU-EMJbo83TogPtuQ3ePbSJTR_8eCk6D6TqW8eyAFyBGH3R2KoxLiqw6KXX5_mn9BpkmXf30qnwfWSFYXk-cHGylhdsDCJo2fW9uW8_j3uawHVMXL2sOQtI99ZxtnRr3SO0R1I2S76C09PTE3b0nJ_W47pyuApyHQxHugiMJ5M8JBGp-d-udkme9bbmOsVx4ZYG4Wnhwvk9X_WfC-IAbga_b2x5O-WnT7UrYiMInCxfCQkz3XpKrOtwJ3PRpA8BJT2P0jF_TN0oRpwjZJWgvPzNBetGTRZiuBRxX7lozQB8CRMiv39Hcyynm1ctnqHnPoqZW7pz_uHoaEzWQifbq5sy574reAIcanx3ck8KGRH0twFmgG7-HhbO0VjZF1pof_ia9XrBP6rl4Fd6F_i5JUSXF24S5-eD8J5SYYuMMeT0AXbybrlJGIhiWBdu85Mxd0EQX1X7lmibAKuP6D74uYTyZEzyrfdydGh04hUT_5-hoJPvhuNWDx0dr-d4_T5sTZo5cujAdk3rE9OEM5XUOtlw8rFCbrtgFqZemNZxb4voqPKQkRkXr-6uREPZSycgAxpdxg7CV7tEzRUiD9_RuHSzHYHqRXm2_3Aw9IQeRssCWXvov-y43KtA',
        //   // },
        // ),
      ),
    );
    _initPusher();
  }

  Future<void> _initPusher() async {
    await pusher!.connect();
    Channel channel = pusher!.subscribe('my-channel');
    // pusher!.onConnectionStateChange((state) {
    //   log("previousState: ${state!.previousState}, currentState: ${state.currentState}");
    // });

    // pusher!.onConnectionError((error) {
    //   log("error: ${error!.message}");
    // });

    // channel.bind('my-event', (event) {
    //   print('event!.data ${event!.data}');
    //   log(event.data!);
    // });

    // channel.bind('my-event', (event) {
    //   print('event!.data ${event!.data}');

    //   log("Order Filled Event${event.data}");
    // });
    channel.bind('my-event', (event) {
      print('event!.data ${event!.data}');
      print('event!. $event');
      setState(() {
        myEvent = event.data!;
      });
    });
  }

  // @override
  // void dispose() {
  //   pusher!.disconnect();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'final io',
        color: backgroundColor,
        borderRadius: 12.0,
      ),
      body: Text(myEvent),
    );
  }
}
