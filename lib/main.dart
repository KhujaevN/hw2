import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Map<String, Object>> questions = [
    {
      'question': 'Who is the director of this movie?',
      'image': 'lib/Images/poster1.jpeg',
      'answers': ['Christopher Nolan', 'Quentin Tarantino', 'Ridley Scott', 'Stanley Kubrick'],
      'correctAnswer': 'Stanley Kubrick',
    },
    {
      'question': 'Who is the director of this movie',
      'image': 'lib/Images/poster2.jpeg',
      'answers': ['Wes Anderson', 'Robert Zemickes', 'Zack Snyder', 'Christopher Nolan'],
      'correctAnswer': 'Robert Zemickes',
    },
  ];

  int currentQuestionIndex = 0;
  int score = 0;

  void checkAnswer(String selectedAnswer) {
    String correctAnswer = questions[currentQuestionIndex]['correctAnswer'] as String;

    if (selectedAnswer == correctAnswer) {
      setState(() {
        score++;
      });

      print('Correct!');
    } else {
      print('Incorrect!');
    }
  }

  void nextQuestion() {
    setState(() {
      currentQuestionIndex = (currentQuestionIndex + 1) % questions.length;
    });
  }

  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Quiz App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Question with Image
            questions[currentQuestionIndex]['image'] != null
                ? Image.asset(
              questions[currentQuestionIndex]['image'] as String,
              height: 200,
              width: 200,
            )
                : Container(),
            SizedBox(height: 20),

            // Question
            Text(
              questions[currentQuestionIndex]['question'] as String,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),

            // Answers
            ...(questions[currentQuestionIndex]['answers'] as List<String>).map((answer) {
              return AnswerButton(
                answerText: answer,
                onPressed: () {
                  checkAnswer(answer);
                },
              );
            }).toList(),

            // Next Question Button
            ElevatedButton(
              onPressed: () {
                if (currentQuestionIndex == questions.length - 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScoreScreen(score: score, onReset: resetQuiz),
                    ),
                  );
                } else {
                  nextQuestion();
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo),
              ),
              child: Text('Next Question'),
            ),
          ],
        ),
      ),
    );
  }
}

class AnswerButton extends StatelessWidget {
  final String answerText;
  final VoidCallback onPressed;

  AnswerButton({required this.answerText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(answerText),
      ),
    );
  }
}

class ScoreScreen extends StatelessWidget {
  final int score;
  final VoidCallback onReset;

  ScoreScreen({required this.score, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Score: $score'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onReset,
              child: Text('Restart Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
