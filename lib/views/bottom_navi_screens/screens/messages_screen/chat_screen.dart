import 'package:flutter/material.dart';
import '../../../../customwidgets/customtext.dart';
import '../../../../customwidgets/customtextformfield.dart';

class ChatScreen extends StatefulWidget {
  final String contactName;
  final String profileImage;

  const ChatScreen({
    super.key,
    required this.contactName,
    required this.profileImage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  bool _isTextFieldFocused = false;
  bool _showExtraIcons = false; // 👈 toggle for expandable icons

  @override
  void initState() {
    super.initState();
    _messageFocusNode.addListener(_onFocusChange);

    // Sample messages
    _messages.addAll([
      ChatMessage(text: "Hello there!", isMe: false, time: "2:58 PM"),
      ChatMessage(
        text: "I was looking on Internet and I saw this Webflow template!",
        isMe: false,
        time: "2:58 PM",
      ),
      ChatMessage(
        text: "https://financetemplate.webflow.io\n\nFinancelab",
        isMe: false,
        time: "2:58 PM",
        hasImage: true,
        imageUrl: "assets/images/backgrondimage.png",
      ),
      ChatMessage(
        text: " Financelab X - Webflow Ecommerce Website Template",
        isMe: false,
        time: "2:59 PM",
      ),
      ChatMessage(
        text: "We should catch up soon!We should catch up soon!",
        isMe: false,
        time: "2:59 PM",
      ),
      ChatMessage(text: "Hi there! Nice to meet you!", isMe: true, time: "2:59 PM"),
    ]);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isTextFieldFocused = _messageFocusNode.hasFocus;
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour}:${minute.toString().padLeft(2, '0')} $period';
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: _messageController.text.trim(),
            isMe: true,
            time: _getCurrentTime(),
          ),
        );
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/second_background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 24,
                  vertical: isSmallScreen ? 14 : 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: isSmallScreen ? 24 : 28,
                      ),
                    ),
                    SizedBox(width: isSmallScreen ? 16 : 20),
                    CircleAvatar(
                      radius: isSmallScreen ? 18 : 22,
                      backgroundImage: AssetImage(widget.profileImage),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            widget.contactName,
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          CustomText(
                            "Active 19m ago",
                            fontSize: isSmallScreen ? 12 : 14,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: isSmallScreen ? 20 : 22,
                      ),
                    ),
                  ],
                ),
              ),

              // MESSAGES
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageBubble(_messages[index], screenWidth);
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

  Widget _buildMessageBubble(ChatMessage message, double screenWidth) {
    final isSmallScreen = screenWidth < 600;

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: isSmallScreen ? 16 : 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isMe) ...[
              CircleAvatar(
                radius: isSmallScreen ? 16 : 20,
                backgroundImage: AssetImage(widget.profileImage),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
            ],
            Flexible(
              child: Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                constraints: BoxConstraints(
                  maxWidth: screenWidth * (isSmallScreen ? 0.7 : 0.6),
                ),
                decoration: BoxDecoration(
                  color: message.isMe
                      ? const Color(0xFF9558F8).withOpacity(0.9)
                      : Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isSmallScreen ? 20 : 24),
                    topRight: Radius.circular(isSmallScreen ? 20 : 24),
                    bottomLeft: Radius.circular(
                      message.isMe ? (isSmallScreen ? 20 : 24) : (isSmallScreen ? 8 : 12),
                    ),
                    bottomRight: Radius.circular(
                      message.isMe ? (isSmallScreen ? 8 : 12) : (isSmallScreen ? 20 : 24),
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (message.hasImage && message.imageUrl != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
                        child: Image.asset(
                          message.imageUrl!,
                          height: isSmallScreen ? 120 : 150,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 12),
                    ],
                    ...message.text.split('\n').map((line) {
                      if (line.trim().isEmpty) {
                        return SizedBox(height: isSmallScreen ? 8 : 12);
                      }
                      return Padding(
                        padding: EdgeInsets.only(bottom: isSmallScreen ? 4 : 6),
                        child: CustomText(
                          line,
                          fontSize: isSmallScreen ? 14 : 16,
                          color: message.isMe ? Colors.white : Colors.black,
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
            if (!message.isMe) ...[
              SizedBox(width: isSmallScreen ? 8 : 12),
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.share,
                  color: Colors.grey,
                  size: isSmallScreen ? 16 : 18,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  final bool hasImage;
  final String? imageUrl;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.hasImage = false,
    this.imageUrl,
  });
}
