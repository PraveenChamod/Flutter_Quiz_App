import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linear_timer/linear_timer.dart';
import '../../common_widgets/answer_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    fetchImageURL();
  }

  late LinearTimerController timerController = LinearTimerController(this);
  @override
  void dispose() {
    timerController.dispose();
    super.dispose();
  }

  int quizNumber = 1;
  int score = 0;

  String imageUrl = '';
  int answerValue = 0;
  int? trueItem;
  Map<int, bool> isClickedMap = {
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
    6: false,
    7: false,
    8: false,
    9: false,
    0: false,
  };

  int countDown = 20;
  late Timer _timer;
  bool countDownAction = false;

  // void startCountdown() {
  //   const oneSecond = Duration(seconds: 1);
  //   Timer.periodic(oneSecond, (Timer timer) {
  //     if (countDown > 0) {
  //       setState(() {
  //         countDown = countDown - 1;
  //       });
  //     }else{
  //       stopCountdown();
  //     }
  //   });
  // }

  void startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countDown > 0) {
        setState(() {
          countDown--;
        });
      } else {
        stopCountdown();
      }
    });
  }

  void stopCountdown() {
    _timer.cancel();
    setState(() {
      countDownAction = false;
    });
  }

  void resetCountdown() {
    _timer.cancel();
    setState(() {
      countDown = 20;
      countDownAction = false;
    });
  }

  bool isSubmitClicked = false;
  void _handleSubmit() {
    stopCountdown();
    timerController.stop();
    for (var entry in isClickedMap.entries) {
      if (entry.value == true) {
        trueItem = entry.key;
        break;
      }
    }
    if (trueItem != null) {
      if(trueItem == answerValue){
        awesomeDialog(DialogType.success, "Take Your Next Challenge.", "Quiz $quizNumber Completed!");
      }
      else{
        failureMismatchAwesomeDialog(DialogType.warning, "Try Again!", "Oops Answer Is Incorrect!");
      }
    } else {
      failureNoItemAwesomeDialog(DialogType.warning, "Try Again!", "Please Select An Answer First!");
    }
    setState(() {
      isSubmitClicked = !isSubmitClicked;
    });
  }

  Future<void> fetchImageURL() async {
    final response = await http.get(Uri.parse('https://marcconrad.com/uob/smile/api.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final imageURL = data['question'] as String;
      final solution = data['solution'];
      setState(() {
        imageUrl = imageURL;
        answerValue = solution;
      });
    }
    startAwesomeDialog(DialogType.noHeader, "Start Your Challenge Now!", "Here Quiz No: $quizNumber");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8024d4), Color(0xFF260f3c)],
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.transparent,
                    child: SafeArea(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: Color(0xFFae27f2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(0),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                child: const Text(
                                  textAlign: TextAlign.center,
                                  "Welcome Kevin",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                                ),

                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            textAlign: TextAlign.center,
                                            "Quiz No: ",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "$quizNumber",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                              color: Color(0xFF39FF14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            textAlign: TextAlign.center,
                                            "Score: ",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            textAlign: TextAlign.center,
                                            "$score",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.normal,
                                              color: Color(0xFF39FF14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        image: const DecorationImage(
                                          image: AssetImage('assets/timer.png'),
                                          fit: BoxFit.fitWidth,
                                        ),
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.amberAccent,
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: LinearTimer(
                                              duration: const Duration(seconds: 20),
                                              backgroundColor: Colors.white,
                                              color: Colors.indigoAccent,
                                              controller: timerController,
                                              onTimerEnd: () {
                                                failureAwesomeDialog(DialogType.warning, "Try Again!", "Oops Time Is Over!");
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            color: Colors.transparent,
                                            margin: const EdgeInsets.only(
                                              right: 20,
                                            ),
                                            child: Text(
                                              textAlign: TextAlign.right,
                                              "Remaining time $countDown seconds",
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            color: Colors.transparent,
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                image: imageUrl.isNotEmpty
                                    ? DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                                gradient: const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xFFae27f2), Color(0xFF6d15b5)],
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            color: Colors.transparent,
                            child: Container(
                              margin: const EdgeInsets.only(
                                left: 20,
                                top: 0,
                                right: 20,
                                bottom: 20,
                              ),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xFF672997), Color(0xFF2e1643)],
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                            ),

                                            child: NumberButton(
                                              keypadNumber: 1,
                                              isClicked: isClickedMap[1] as bool,
                                              onPressed: () {
                                                setState(() {
                                                  isClickedMap.forEach((key, value) {
                                                    isClickedMap[key] = false;
                                                  });
                                                  isClickedMap[1] = true;
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                              left: 10,
                                            ),
                                            child: NumberButton(
                                              keypadNumber: 2,
                                              isClicked: isClickedMap[2] as bool,
                                              onPressed: () {
                                                setState(() {
                                                  isClickedMap.forEach((key, value) {
                                                    isClickedMap[key] = false;
                                                  });
                                                  isClickedMap[2] = true;
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              left: 10,
                                            ),
                                            child: NumberButton(
                                              keypadNumber: 3,
                                              isClicked: isClickedMap[3] as bool,
                                              onPressed: () {
                                                setState(() {
                                                  isClickedMap.forEach((key, value) {
                                                    isClickedMap[key] = false;
                                                  });
                                                  isClickedMap[3] = true;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: NumberButton(
                                              keypadNumber: 4,
                                              isClicked: isClickedMap[4] as bool,
                                              onPressed: () {
                                                setState(() {
                                                  isClickedMap.forEach((key, value) {
                                                    isClickedMap[key] = false;
                                                  });
                                                  isClickedMap[4] = true;
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                              left: 10,
                                            ),
                                            child: NumberButton(
                                              keypadNumber: 5,
                                              isClicked: isClickedMap[5] as bool,
                                              onPressed: () {
                                                setState(() {
                                                  isClickedMap.forEach((key, value) {
                                                    isClickedMap[key] = false;
                                                  });
                                                  isClickedMap[5] = true;
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              left: 10,
                                            ),
                                            child: NumberButton(
                                              keypadNumber: 6,
                                              isClicked: isClickedMap[6] as bool,
                                              onPressed: () {
                                                setState(() {
                                                  isClickedMap.forEach((key, value) {
                                                    isClickedMap[key] = false;
                                                  });
                                                  isClickedMap[6] = true;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: NumberButton(
                                              keypadNumber: 7,
                                              isClicked: isClickedMap[7] as bool,
                                              onPressed: () {
                                                setState(() {
                                                  isClickedMap.forEach((key, value) {
                                                    isClickedMap[key] = false;
                                                  });
                                                  isClickedMap[7] = true;
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                              left: 10,
                                            ),
                                            child: NumberButton(
                                              keypadNumber: 8,
                                              isClicked: isClickedMap[8] as bool,
                                              onPressed: () {
                                                setState(() {
                                                  isClickedMap.forEach((key, value) {
                                                    isClickedMap[key] = false;
                                                  });
                                                  isClickedMap[8] = true;
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              left: 10,
                                            ),
                                            child: NumberButton(
                                              keypadNumber: 9,
                                              isClicked: isClickedMap[9] as bool,
                                              onPressed: () {
                                                setState(() {
                                                  isClickedMap.forEach((key, value) {
                                                    isClickedMap[key] = false;
                                                  });
                                                  isClickedMap[9] = true;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child: NumberButton(
                                              keypadNumber: 0,
                                              isClicked: isClickedMap[0] as bool,
                                              onPressed: () {
                                                setState(() {
                                                  isClickedMap.forEach((key, value) {
                                                    isClickedMap[key] = false;
                                                  });
                                                  isClickedMap[0] = true;
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              left: 10,
                                            ),
                                            child: Center(
                                              child: Container(
                                                width: 160,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: isSubmitClicked ? Colors.green : const Color(0xFFae27f2),
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10),
                                                    bottomLeft: Radius.circular(10),
                                                    bottomRight: Radius.circular(10),
                                                  ),
                                                ),
                                                child: OutlinedButton(
                                                  style: OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                      color: isSubmitClicked ? const Color(0xFFae27f2) : Colors.white,
                                                      width: 2.0,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    ),
                                                  ),
                                                  onPressed: _handleSubmit,
                                                  child: Stack(
                                                    children: [
                                                      Text(
                                                        'Submit',
                                                        style: TextStyle(
                                                          fontSize: 30,
                                                          letterSpacing: 1,
                                                          fontWeight: FontWeight.bold,
                                                          foreground: Paint()
                                                            ..style = PaintingStyle.stroke
                                                            ..strokeWidth = 3
                                                            ..color = Colors.black,
                                                        ),
                                                      ),
                                                      const Text(
                                                        'Submit',
                                                        style: TextStyle(
                                                          fontSize: 30,
                                                          letterSpacing: 1,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  awesomeDialog(DialogType type, String desc, String title) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.topSlide,
      showCloseIcon: false,
      title: title,
      desc: desc,
      btnOkOnPress: (){
        resetCountdown();
        fetchImageURL();
        setState(() {
          quizNumber += 1;
          score += 10;
        });
      },
    ).show();
  }
  startAwesomeDialog(DialogType type, String desc, String title) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.topSlide,
      showCloseIcon: false,
      title: title,
      desc: desc,
      btnOkOnPress: (){
        timerController.reset();
        timerController.start();
        if (!countDownAction) {
          startCountdown();
          setState(() {
            countDownAction = true;
          });
        }
        setState(() {
          if(isSubmitClicked){
            isSubmitClicked = !isSubmitClicked;
          }
          isClickedMap.forEach((key, value) {
            isClickedMap[key] = false;
          });
        });
      },
    ).show();
  }
  failureAwesomeDialog(DialogType type, String desc, String title) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.topSlide,
      showCloseIcon: false,
      title: title,
      desc: desc,
      btnOkOnPress: (){
        resetCountdown();
        startCountdown();
        timerController.reset();
        timerController.start();
        setState(() {
          if(isSubmitClicked){
            isSubmitClicked = !isSubmitClicked;
          }
          isClickedMap.forEach((key, value) {
            isClickedMap[key] = false;
          });
        });
      },
    ).show();
  }
  failureMismatchAwesomeDialog(DialogType type, String desc, String title) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.topSlide,
      showCloseIcon: false,
      title: title,
      desc: desc,
      btnOkOnPress: (){
        resetCountdown();
        startCountdown();
        timerController.reset();
        timerController.start();
        setState(() {
          if(isSubmitClicked){
            isSubmitClicked = !isSubmitClicked;
          }
          isClickedMap.forEach((key, value) {
            isClickedMap[key] = false;
          });
        });
      },
    ).show();
  }
  failureNoItemAwesomeDialog(DialogType type, String desc, String title) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.topSlide,
      showCloseIcon: false,
      title: title,
      desc: desc,
      btnOkOnPress: (){
        resetCountdown();
        startCountdown();
        timerController.reset();
        timerController.start();
        setState(() {
          if(isSubmitClicked){
            isSubmitClicked = !isSubmitClicked;
          }
        });
      },
    ).show();
  }
}
