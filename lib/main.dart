import 'package:flutter/material.dart';

void main() => runApp(const SignUpApp());

class SignUpApp extends StatelessWidget {
  const SignUpApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const SignUpScreen(),
        '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}

// 脚手架
class SignUpScreen extends StatelessWidget {
  const SignUpScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome!',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}

// 表单
class SignUpForm extends StatefulWidget {
  const SignUpForm();

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();

  // 进度
  double _formProgress = 0;

  // 登录后展示欢迎页面的回调
  void _showWelcomeScreen(){
    Navigator.of(context).pushNamed("/welcome");
  }

  // 更新进度条的回调
  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _firstNameTextController,
      _lastNameTextController,
      _usernameTextController,
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // LinearProgressIndicator(value: _formProgress),
          AnimateProgressIndicator(value: _formProgress,),
          Text('Sign up', style: Theme.of(context).textTheme.headline4),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _firstNameTextController,
              decoration: const InputDecoration(hintText: 'First name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(hintText: 'Last name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: const InputDecoration(hintText: 'Username'),
            ),
          ),
          // 登录按钮
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.white;
              }),
              backgroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                return states.contains(MaterialState.disabled)
                    ? null
                    : Colors.blue;
              }),
            ),
            onPressed: _formProgress == 1 ?  _showWelcomeScreen : null,
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }
}

class AnimateProgressIndicator extends StatefulWidget {
  const AnimateProgressIndicator({Key? key, required this.value}) : super(key: key);

  final double value;

  @override
  State<AnimateProgressIndicator> createState() => _AnimateProgressIndicatorState();
}

class _AnimateProgressIndicatorState extends State<AnimateProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this
    );

    // 渐变队列
    final colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(
          begin: Colors.red,
          end: Colors.orange,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: Colors.orange,
          end: Colors.yellow,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: Colors.yellow,
          end: Colors.green,
        ),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn)); // 曲线渐变？ 
  }

  @override
  void didUpdateWidget(oldWidget) {
    print(_curveAnimation.value);
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value?.withOpacity(0.4),
      ),
    );
  }
}
