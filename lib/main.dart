import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asets/sg.jpg',
              width: 200,
              height: 200,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizPage()),
                );
              },
              child: const Text('Start Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Question> questions = [
    Question(
      ' What is a variable in programming?',
      [' A storage location with a symbolic name', 'A way to store multiple values in a single container', ' A type of data structure'],
      1,
    ),
    Question(
      'What programming language is used in Flutter?',
      ['Dart', 'Java', 'Python'],
      0,
    ),
   Question(
  'What is an algorithm in programming?',
  [
    'A step-by-step procedure for solving a problem',
    'A type of variable',
    ' A programming language'
  ],
  0,
),
Question(
    ' What is the purpose of a loop in programming?',
  [
    ' To repeat a block of code multiple times',
    ' To store data in memory',
    ' To display output on the screen',
  ],
  2,
),
Question(
  ' Which programming language is known for its simplicity and readability?',
  [
    'Python',
    'C++',
    ' Ruby'
  ],
  0,
),
  ];

  int currentQuestionIndex = 0;
  int score = 0;
  List<int> selectedAnswers = List.filled(6, -1);
  List<int> correctAnswers = [];

  void checkAnswer(int selectedAnswerIndex) {
    setState(() {
      selectedAnswers[currentQuestionIndex] = selectedAnswerIndex;
      correctAnswers.add(questions[currentQuestionIndex].correctAnswerIndex);

      if (selectedAnswerIndex == questions[currentQuestionIndex].correctAnswerIndex) {
        score++;
      }

      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ResultPage(score: score, totalQuestions: questions.length, correctAnswers: correctAnswers, selectedAnswers: selectedAnswers, questions: questions)),
        );
      }
    });
  }

  void goBack() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        title: const Text('Flutter Quiz'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Question ${currentQuestionIndex + 1}/${questions.length}',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              questions[currentQuestionIndex].questionText,
              style: const TextStyle(fontSize: 24, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            children: [
              for (int i = 0; i < questions[currentQuestionIndex].choices.length; i++)
                RadioListTile<int>(
                  title: Text(
                    questions[currentQuestionIndex].choices[i],
                    style: const TextStyle(color: Colors.white),
                  ),
                  value: i,
                  groupValue: selectedAnswers[currentQuestionIndex],
                  onChanged: (int? value) {
                    setState(() {
                      selectedAnswers[currentQuestionIndex] = value!;
                    });
                  },
                ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: goBack,
                child: const Text('Back'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  checkAnswer(selectedAnswers[currentQuestionIndex]);
                },
                child: Text(currentQuestionIndex < questions.length - 1 ? 'Next' : 'Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<int> correctAnswers;
  final List<int> selectedAnswers;
  final List<Question> questions;

  const ResultPage({Key? key, required this.score, required this.totalQuestions, required this.correctAnswers, required this.selectedAnswers, required this.questions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        title: const Text('Quiz Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Completed!',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            Text(
              'Your Score: $score/$totalQuestions',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
            for (int i = 0; i < totalQuestions; i++)
              Text(
                'Question ${i + 1}: ${correctAnswers[i] == selectedAnswers[i] ? 'Correct' : 'Incorrect'}, Correct Answer: ${questions[i].choices[questions[i].correctAnswerIndex]}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
              },
              child: const Text('Restart Quiz'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Finish'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Thank you for the visit!',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
class Question {
  final String questionText;
  final List<String> choices;
  final int correctAnswerIndex;

  Question(this.questionText, this.choices, this.correctAnswerIndex);
}