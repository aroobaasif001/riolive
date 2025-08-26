import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riolive/customwidgets/custom_container.dart';
import 'package:riolive/customwidgets/customtext.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _textController = TextEditingController();
  int _characterCount = 0;
  final int _maxCharacters = 250;

  final List<String> _recommendedTopics = [
    '#Everyday life',
    '#SHOW YOURSELF',
    '#Topics you are interested in',
    '#Everyday life',
    '#SHOW YOURSELF',
  ];

  final List<Color> _topicColors = [
    const Color(0xFF87CEEB), // Light blue
    const Color(0xFFDDA0DD), // Light purple
    const Color(0xFFDDA0DD), // Light purple
    const Color(0xFF87CEEB), // Light blue
    const Color(0xFFDDA0DD), // Light purple
  ];

  @override
  void initState() {
    super.initState();
    _textController.addListener(_updateCharacterCount);
  }

  @override
  void dispose() {
    _textController.removeListener(_updateCharacterCount);
    _textController.dispose();
    super.dispose();
  }

  void _updateCharacterCount() {
    setState(() {
      _characterCount = _textController.text.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomContainer(
        image: DecorationImage(image: AssetImage('assets/images/m&mBackground.png'), fit: BoxFit.fill),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      // Post functionality
                      Navigator.pop(context);
                    },
                    child: const CustomText(
                      'Post',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              // Text Input Area
              const SizedBox(height: 30),
              CustomContainer(
                conColor: const Color(0x99d9d9d9),
                borderRadius: BorderRadius.circular(16),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _textController,
                      maxLines: 6,
                      maxLength: _maxCharacters,
                      decoration: const InputDecoration(
                        hintText: 'Say something to record this moment...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        counterText: '', // Hide default counter
                      ),
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    CustomText('$_characterCount/$_maxCharacters', fontSize: 12, color: Colors.grey),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Media Upload Area
              Row(
                children: [
                  CustomContainer(
                    conColor: const Color(0x99d9d9d9),
                    borderRadius: BorderRadius.circular(12),
                    width: 80,
                    height: 80,
                    child: Material(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0x99d9d9d9),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {},
                        child: const Center(child: Icon(CupertinoIcons.plus, size: 32, color: Colors.grey)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Mentions Section
              Row(
                children: [
                  const CustomText(
                    '@ Mention',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,

                    color: Colors.black,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Recommended Topics Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    '# Recommended topics',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      _recommendedTopics.length,
                      (index) => GestureDetector(
                        onTap: () {
                          // Add topic to text
                          final topic = _recommendedTopics[index];
                          final currentText = _textController.text;
                          _textController.text = currentText.isEmpty ? topic : '$currentText $topic';
                        },
                        child: CustomContainer(
                          conColor: _topicColors[index],
                          borderRadius: BorderRadius.circular(20),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: CustomText(
                            _recommendedTopics[index],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // End Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF90EE90), // Light green
                        Color(0xFFDDA0DD), // Light purple
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Post functionality
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const CustomText(
                      'End',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
}
