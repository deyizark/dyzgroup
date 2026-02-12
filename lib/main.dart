import 'package:flutter/material.dart';


Map<String, String> fakeDatabase = {
  "lakoukajou@gmail.com": "poutimoun",
};

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("Imaj/logo.png",
            width = 100,
            height = 100
            ),
            SizedBox(height: 20),
            Text(
              "Aprann ak kè kontan",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class VirtualKeyboard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onClose;

  const VirtualKeyboard({
    super.key,
    required this.controller,
    required this.onClose,
  });

  void addText(String value) {
    controller.text += value;
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  void deleteText() {
    if (controller.text.isNotEmpty) {
      controller.text =
          controller.text.substring(0, controller.text.length - 1);
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }
  }

  Widget buildKey(String text,
      {VoidCallback? onPressed, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: SizedBox(
          height: 36,
          child: ElevatedButton(
            onPressed: onPressed ?? () => addText(text),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRow(List<String> keys) {
    return Row(
      children: keys.map((k) => buildKey(k)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildRow(["1","2","3","4","5","6","7","8","9","0"]),
          buildRow(["q","w","e","r","t","y","u","i","o","p"]),
          buildRow(["a","s","d","f","g","h","j","k","l"]),
          buildRow(["z","x","c","v","b","n","m","@","."]),
          Row(
            children: [
              buildKey("Space",
                  onPressed: () => addText(" "), flex: 3),
              buildKey("⌫",
                  onPressed: deleteText, flex: 2),
              buildKey("Fèmen",
                  onPressed: onClose, flex: 2),
            ],
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  TextEditingController? activeController;

  bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  void openKeyboard(TextEditingController controller) {
    setState(() => activeController = controller);
  }

  void closeKeyboard() {
    setState(() => activeController = null);
  }

  void login() {
    closeKeyboard();

    if (_formKey.currentState!.validate()) {
      if (fakeDatabase.containsKey(emailController.text) &&
          fakeDatabase[emailController.text] ==
              passwordController.text) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                HomePage(email: emailController.text),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Imel oubyen modpas enkòrèk")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Koneksyon")),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      readOnly: true,
                      onTap: () =>
                          openKeyboard(emailController),
                      decoration: const InputDecoration(
                        labelText: "Imel",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return "Imel la obligatwa";
                        }
                        if (!isValidEmail(value)) {
                          return "Imel la pa nan bon fòma";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passwordController,
                      readOnly: true,
                      obscureText: true,
                      onTap: () =>
                          openKeyboard(passwordController),
                      decoration: const InputDecoration(
                        labelText: "Modpas",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return "Modpas la obligatwa";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: login,
                      child: const Text("Koneksyon"),
                    ),
                    TextButton(
                      onPressed: () {
                        closeKeyboard();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const SignupPage(),
                          ),
                        );
                      },
                      child:
                      const Text("Pa gen kont? Kreye youn"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (activeController != null)
            VirtualKeyboard(
              controller: activeController!,
              onClose: closeKeyboard,
            ),
        ],
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  TextEditingController? activeController;

  bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  void openKeyboard(TextEditingController controller) {
    setState(() => activeController = controller);
  }

  void closeKeyboard() {
    setState(() => activeController = null);
  }

  void signup() {
    closeKeyboard();

    if (_formKey.currentState!.validate()) {
      if (fakeDatabase.containsKey(emailController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Imel sa egziste deja")),
        );
      } else {
        fakeDatabase[emailController.text] =
            passwordController.text;

        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Bravo! Kont ou an kreye")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text("Anrejistre")),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding:
              const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      readOnly: true,
                      onTap: () =>
                          openKeyboard(emailController),
                      decoration:
                      const InputDecoration(
                        labelText: "Imel",
                        border:
                        OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return "Imel la obligatwa";
                        }
                        if (!isValidEmail(value)) {
                          return "Imel la pa nan bon fòma";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller:
                      passwordController,
                      readOnly: true,
                      obscureText: true,
                      onTap: () =>
                          openKeyboard(
                              passwordController),
                      decoration:
                      const InputDecoration(
                        labelText: "Modpas",
                        border:
                        OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty) {
                          return "Modpas la obligatwa";
                        }
                        if (value.length < 8) {
                          return "Mete 8 karaktè pou pi piti";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller:
                      confirmController,
                      readOnly: true,
                      obscureText: true,
                      onTap: () =>
                          openKeyboard(
                              confirmController),
                      decoration:
                      const InputDecoration(
                        labelText:
                        "Komfime Modpas",
                        border:
                        OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value !=
                            passwordController
                                .text) {
                          return "Modpas yo pa menm";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: signup,
                      child: const Text(
                          "Kreye Kont"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (activeController != null)
            VirtualKeyboard(
              controller: activeController!,
              onClose: closeKeyboard,
            ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final String email;

  const HomePage(
      {super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Akèy"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text(
          "Byenvini, $email",
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}