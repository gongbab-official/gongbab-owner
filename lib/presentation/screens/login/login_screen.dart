import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Input mode: true for number keypad, false for alphabet keypad
  bool isNumberMode = true;

  // Store the 5 input values (4 numbers + 1 letter)
  List<String?> inputs = [null, null, null, null, null];
  int currentIndex = 0;

  void _onNumberPressed(String number) {
    if (currentIndex < 4) {
      setState(() {
        inputs[currentIndex] = number;
        currentIndex++;
        // Switch to alphabet mode after 4 digits
        if (currentIndex == 4) {
          isNumberMode = false;
        }
      });
    }
  }

  void _onLetterPressed(String letter) {
    if (currentIndex == 4) {
      setState(() {
        inputs[currentIndex] = letter;
        currentIndex++;
      });
    }
  }

  void _onBackspace() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        inputs[currentIndex] = null;
        // Switch back to number mode if clearing from alphabet
        if (currentIndex < 4) {
          isNumberMode = true;
        }
      }
    });
  } // 여기에 닫는 중괄호 추가

  void _onClearAll() {
    setState(() {
      inputs = [null, null, null, null, null];
      currentIndex = 0;
      isNumberMode = true; // Reset to number mode
    });
  }

  void _onLogin() {
    if (currentIndex == 5) {
      // All inputs filled, proceed with login
      String pin = inputs.sublist(0, 4).join();
      String alphabet = inputs[4]!;

      // TODO: Implement login logic
      print('PIN: $pin, Alphabet: $alphabet');

      // Navigate to next screen or show error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Title
              const Text(
                '관리자 로그인',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              // Subtitle
              const Text(
                '번호 4자리 + 알파벳 1자리',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 60),
              // Input dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                      (index) =>
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: _buildInputDot(index),
                      ),
                ),
              ),
              const SizedBox(height: 60),
              // Keypad
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: isNumberMode
                      ? _buildNumberKeypad()
                      : _buildAlphabetKeypad(),
                ),
              ),
              const SizedBox(height: 20),
              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: currentIndex == 5 ? _onLogin : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    disabledBackgroundColor: const Color(0xFF1E293B),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      color: currentIndex == 5 ? Colors.white : const Color(
                          0xFF64748B),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputDot(int index) {
    bool isFilled = inputs[index] != null;
    bool isActive = currentIndex == index;
    bool isAlphabet = index == 4;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF1A2332),
        border: Border.all(
          color: isActive ? const Color(0xFF3B82F6) : const Color(0xFF2D3748),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: isAlphabet && !isFilled
            ? const Text(
          'A',
          style: TextStyle(
            color: Color(0xFF3B82F6),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        )
            : isFilled
            ? Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        )
            : null,
      ),
    );
  }

  Widget _buildNumberKeypad() {
    return Column(
      children: [
        // Tab buttons
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isNumberMode = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: isNumberMode
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF1A2332),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '숫자 키패드',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isNumberMode = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: !isNumberMode
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF1A2332),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '알파벳',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Number pad
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKeypadButton('1', _onNumberPressed),
            _buildKeypadButton('2', _onNumberPressed),
            _buildKeypadButton('3', _onNumberPressed),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKeypadButton('4', _onNumberPressed),
            _buildKeypadButton('5', _onNumberPressed),
            _buildKeypadButton('6', _onNumberPressed),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildKeypadButton('7', _onNumberPressed),
            _buildKeypadButton('8', _onNumberPressed),
            _buildKeypadButton('9', _onNumberPressed),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildClearButton(),
            _buildKeypadButton('0', _onNumberPressed),
            _buildBackspaceButton(),
          ],
        ),
        const SizedBox(height: 20),
        // Alphabet hint
        const Text(
          '빠른 알파벳 입력',
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAlphabetButton('A'),
            _buildAlphabetButton('B'),
            _buildAlphabetButton('C'),
            _buildAlphabetButton('D'),
            _buildAlphabetButton('E'),
          ],
        ),
      ],
    );
  }

  Widget _buildAlphabetKeypad() {
    const letters = [
      ['A', 'B', 'C', 'D', 'E'],
      ['F', 'G', 'H', 'I', 'J'],
      ['K', 'L', 'M', 'N', 'O'],
      ['P', 'Q', 'R', 'S', 'T'],
      ['U', 'V', 'W', 'X', 'Y'],
    ];

    return Column(
      children: [
        // Tab buttons
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isNumberMode = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: isNumberMode
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF1A2332),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '숫자 키패드',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isNumberMode = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: !isNumberMode
                        ? const Color(0xFF3B82F6)
                        : const Color(0xFF1A2332),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      '알파벳',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Alphabet pad
        ...letters.map((row) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row
                  .map((letter) => _buildAlphabetKeyButton(letter))
                  .toList(),
            ),
          );
        }).toList(),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildClearButton(),
            _buildAlphabetKeyButton('Z'),
            _buildBackspaceButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildKeypadButton(String number, Function(String) onPressed) {
    return GestureDetector(
      onTap: () => onPressed(number),
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlphabetButton(String letter) {
    bool isSelected = inputs[4] == letter;

    return GestureDetector(
      onTap: () => _onLetterPressed(letter),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : const Color(
                0xFF2D3748),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              color: isSelected ? const Color(0xFF3B82F6) : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlphabetKeyButton(String letter) {
    return GestureDetector(
      onTap: () => _onLetterPressed(letter),
      child: Container(
        width: 64,
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            letter,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClearButton() {
    return GestureDetector(
      onTap: _onClearAll,
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'CLEAR',
            style: TextStyle(
              color: Color(0xFFEF4444),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return GestureDetector(
      onTap: _onBackspace,
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(
            Icons.backspace_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
