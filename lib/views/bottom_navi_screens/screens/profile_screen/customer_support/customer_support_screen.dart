import 'package:flutter/material.dart';

import '../../../../../customwidgets/customtextformfield.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<SupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isTextFieldFocused = false;
  bool _showExtraIcons = false;
  final List<ChatMessage> _messages = [
    ChatMessage(text: "Hello there!", isMe: false),
    ChatMessage(
        text:
        "I was looking on Internet and I saw this Webflow template from you guys!",
        isMe: false),
    ChatMessage(
        text: "We should catch up soon!We should catch up soon!We",
        isMe: false),
    ChatMessage(text: "Hi there! Nice to meet you!.", isMe: true),
    ChatMessage(
        text:
        "I’m John and today I’m going to help you to find your perfect Webflow Template 👇",
        isMe: true),
    ChatMessage(
        text:
        "We should catch up soon!We should catch up soon!We should catch up soon!We should catch up soon!",
        isMe: false),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: _messageController.text, isMe: true));
    });
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFD4F1F9), Color(0xFFECDDF6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.black),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Customer Support",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 40), // for symmetry
                  ],
                ),
              ),

              // CHAT LIST
              Expanded(
                child: ListView.builder(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(_messages[index]);
                  },
                ),
              ),

              // INPUT BAR
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 20,
                  vertical: isSmallScreen ? 12 : 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // "+" main icon
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showExtraIcons = !_showExtraIcons;
                        });
                      },
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Colors.black,
                        size: isSmallScreen ? 28 : 30,
                      ),
                    ),

                    // Expandable icons
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _showExtraIcons
                          ? Row(
                        key: const ValueKey("icons"),
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.black,
                              size: isSmallScreen ? 24 : 28,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.image_outlined,
                              color: Colors.black,
                              size: isSmallScreen ? 24 : 28,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.mic_outlined,
                              color: Colors.black,
                              size: isSmallScreen ? 24 : 28,
                            ),
                          ),
                        ],
                      )
                          : const SizedBox.shrink(),
                    ),

                    // Message input (custom field)
                    Expanded(
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: isSmallScreen ? 6 : 8),
                        child: CustomTextFormField(
                          hintText: "Message",
                          controller: _messageController,
                          showDivider: false,
                          suffix: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.emoji_emotions_outlined,
                              color: const Color(0xFF9557F9),
                              size: isSmallScreen ? 24 : 28,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Send button
                    IconButton(
                      onPressed: _sendMessage,
                      icon: Icon(
                        Icons.send,
                        color: Colors.black,
                        size: isSmallScreen ? 24 : 28,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isMe = message.isMe;
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF9558F8) : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        constraints: const BoxConstraints(maxWidth: 280),
        child: Text(
          message.text,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;

  ChatMessage({required this.text, required this.isMe});
}
