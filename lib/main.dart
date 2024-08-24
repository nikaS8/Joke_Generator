import 'dart:async';

import 'package:flutter/material.dart';
import 'package:joke_generater/models/joke.dart';
import 'package:joke_generater/service/JokeService.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke Generator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 28, 244, 208),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Joke of the Day'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final StreamController<Joke> _jokeController =
      StreamController<Joke>.broadcast();
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _fetchJoke();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchJoke();
    });
  }

  Future<void> _fetchJoke() async {
    await Future.delayed(const Duration(seconds: 1));

    if (_timer.isActive) {
      _timer.cancel();
    }

    try {
      Joke joke = await JokeService.browse();
      _animationController.reset();
      _jokeController.add(joke);
      _animationController.forward();
    } catch (e) {
      _jokeController.addError(e);
    } finally {
      _timer = Timer(const Duration(seconds: 10), _fetchJoke);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _jokeController.close();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<Joke>(
                stream: _jokeController.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return _buildJokeCard(snapshot.data!);
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Small problems here',
                            style: TextStyle(color: Colors.red)),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _fetchJoke,
                          child: const Text('Retry'),
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              Text(
                'New joke every 10 seconds',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJokeCard(Joke joke) {
    if (_animation != null) {
      return AnimatedBuilder(
        animation: _animation!,
        builder: (context, child) {
          return Opacity(
            opacity: _animation!.value,
            child: child,
          );
        },
        child: _buildCardContent(joke),
      );
    } else {
      return _buildCardContent(joke);
    }
  }

  Widget _buildCardContent(Joke joke) {
    if (joke.singleJoke != null) {
      return Card(
        elevation: 5,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            joke.singleJoke!.joke,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (joke.twoPartJoke != null) {
      return Card(
        elevation: 5,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                joke.twoPartJoke!.setup,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                joke.twoPartJoke!.delivery,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
