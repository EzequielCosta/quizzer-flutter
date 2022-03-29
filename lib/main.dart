import 'package:flutter/material.dart';
//TODO: Step 2 - Import the rFlutter_Alert package here.
// ignore: import_of_legacy_library_into_null_safe
//import 'package:rflutter_alert/rflutter_alert.dart';
import 'quiz_brain.dart';

QuizBrain quizBrain = QuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [];
  int _hits = 0;
  int _wrong = 0;
  int _skip = 0;

  Future<void> checkIfWrongThreeTimes() async {
    if (_wrong == 3) {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Game Over!'),
              content: Text(
                  "You\'ve wrong 3 times successive \n\n The quiz will restart!"),
              actions: [
                TextButton(
                    onPressed: () {
                      finishedQuiz();
                      Navigator.of(context).pop();
                    },
                    child: Text("Restart")),
              ],
            );
          });
    }
  }

  Future<void> checkIfSkipThreeTimes() async {
    if (_skip == 3) {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Game Over!'),
              content: Text("You\'ve skip 3 times \n\n The quiz will restart!"),
              actions: [
                TextButton(
                    onPressed: () {
                      finishedQuiz();
                      Navigator.of(context).pop();
                    },
                    child: Text("Restart")),
              ],
            );
          });
    }
  }

  Future<void> dialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Finished!'),
            content: Text(
                "You\'ve reached the end of the quiz. You hit ${_hits} questions"),
          );
        });
  }

  void finishedQuiz() {
    quizBrain.reset();

    setState(() {
      _hits = 0;
      scoreKeeper = [];
      _wrong = 0;
      _skip = 0;
    });
  }

  Future<void> finishedQuizDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Finished!'),
              content: Text(
                  "You\'ve reached the end of the quiz. You hit ${_hits} questions"));
        });

    quizBrain.reset();

    setState(() {
      _hits = 0;
      scoreKeeper = [];
      _wrong = 0;
      _skip = 0;
    });
  }

  void checkAnswer([bool? userPickedAnswer = null]) {
    bool correctAnswer = quizBrain.getCorrectAnswer();

    setState(() {
      if (quizBrain.isFinished() == true) {
        finishedQuizDialog();
      } else {
        markAnswer(correctAnswer, userPickedAnswer);
        quizBrain.nextQuestion();
      }
    });
    checkIfWrongThreeTimes();
    checkIfSkipThreeTimes();
  }

  void markAnswer(bool correctAnswer, [bool? userPickedAnswer = null]) {
    if (userPickedAnswer == correctAnswer) {
      _hits += 1;
      scoreKeeper.add(Icon(
        Icons.check,
        color: Colors.green,
      ));
      _wrong = 0; //calculateWrongs(0);
    } else if (userPickedAnswer == null) {
      _skip += 1;
      _wrong = 0; //calculateWrongs(0);
      scoreKeeper.add(Icon(
        Icons.question_mark,
        color: Colors.cyan,
      ));
    } else {
      scoreKeeper.add(Icon(
        Icons.close,
        color: Colors.red,
      ));
      _wrong += 1; //calculateWrongs(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(top: 30),
                child: Center(
                    child: Text(
                  (quizBrain.questionNumber + 1).toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 50),
                )))),
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                //The user picked true.
                checkAnswer(true);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                checkAnswer(false);
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.cyan,
              child: Text(
                'Skip',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                //The user picked false.
                checkAnswer();
              },
            ),
          ),
        ),
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
