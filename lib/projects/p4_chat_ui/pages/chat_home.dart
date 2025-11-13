import 'package:flutter/material.dart';
import '../widgets/message_bubble.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  final List<Map<String, dynamic>> messages = [
    {"text": "Hey, are you free?", "isMe": false},
    {"text": "Yeah, what's up?", "isMe": true},
    {"text": "Just wanted to ask something.", "isMe": false},
    {"text": "Sure, tell me.", "isMe": true},
    {"text": "Do you have the notes from class?", "isMe": false},
    {"text": "I forgot to copy them.", "isMe": false},
    {"text": "Yes, I have them.", "isMe": true},
    {"text": "Want me to send now?", "isMe": true},
    {"text": "Yes please!", "isMe": false},
    {"text": "Okay, sending!", "isMe": true},
  ];


  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final Color primary = const Color.fromARGB(255, 83, 177, 117);

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"text": text, "isMe": true});
    });

    _controller.clear();

    Future.delayed(const Duration(milliseconds: 150), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat UI"),
        backgroundColor: primary,
      ),

      body: Column(
        children: [
          // LIST OF MESSAGES
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                  text: messages[index]["text"],
                  isMe: messages[index]["isMe"],
                );
              },
            ),
          ),

          // INPUT BOX
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.grey.shade200,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: primary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: primary, width: 2),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                CircleAvatar(
                  backgroundColor: primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
