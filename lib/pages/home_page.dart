import 'package:flutter/material.dart';
import 'package:deped_reading_app/data/notifiers.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return Scaffold(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStoryOfTheDay(),
                const SizedBox(height: 20),
                _buildStudentProgress(),
                const SizedBox(height: 20),
                _buildReadAloudChallenge(),
                const SizedBox(height: 20),
                _buildRecommendedStories(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStoryOfTheDay() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Lottie.asset(
              'assets/lotties/rabbit.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 10),
            const Text(
              "📖 Story of the Day: The Brave Little Rabbit",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Read Now"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStudentProgress() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("🏅 Your Progress",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: 0.6, minHeight: 10),
            const SizedBox(height: 5),
            const Text("Level 2 - Keep Going!")
          ],
        ),
      ),
    );
  }

  Widget _buildReadAloudChallenge() {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text("🎤 Read-Aloud Challenge!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Start Reading"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedStories() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("📚 Recommended Stories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Column(
              children: [
                _storyTile("The Curious Cat"),
                _storyTile("The Lost Teddy Bear"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _storyTile(String title) {
    return ListTile(
      leading: Icon(Icons.book, color: Colors.blueAccent),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {},
    );
  }
}
