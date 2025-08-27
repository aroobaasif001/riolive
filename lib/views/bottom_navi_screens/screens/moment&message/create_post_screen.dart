import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        image: DecorationImage(
          image: AssetImage('assets/images/m&mBackground.png'),
          fit: BoxFit.fill,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 24,
                    ),
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
                      decoration: InputDecoration(
                        hintText: 'Say something to record this moment...',
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.poppins(fontSize: 16),
                        counterText: '',
                      ),
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      '$_characterCount/$_maxCharacters',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
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
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.plus,
                            size: 32,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Mentions Section
              Row(
                children: [
                  const CustomText(
                    '@ Mention',
                    fontSize: 16,
                    fontType: AppFont.poppins,
                    fontWeight: FontWeight.w500,
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
                    fontWeight: FontWeight.w500,
                    fontType: AppFont.poppins,
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
                          _textController.text = currentText.isEmpty
                              ? topic
                              : '$currentText $topic';
                        },
                        child: CustomContainer(
                          borderRadius: BorderRadius.circular(20),
                          conColor: Color(0xffE6E7FC),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: CustomText(
                            _recommendedTopics[index],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff5956CB),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // End Button
              CustomContainer(
                height: 57,
                width: 240,
                borderRadius: BorderRadius.circular(28.5),
                border: Border.all(color: Color(0xff29F29C)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3383C69F),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(28.5),
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: () {},
                  child: CustomContainer(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    conColor: Colors.grey.withOpacity(0.3),
                    child: Center(
                      child: CustomText(
                        'End',
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.white,
                      ),
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
