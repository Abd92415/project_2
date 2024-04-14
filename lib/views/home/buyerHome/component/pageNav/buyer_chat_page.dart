import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/services/Firebase/buyer_firestore.dart';
import 'package:graduation_project/services/Firebase/chat_firestore.dart';
import 'package:graduation_project/services/Firebase/seller_firestore.dart';
import 'package:graduation_project/services/Firebase/user_auth.dart';
import 'package:provider/provider.dart';

class BuyerChatPage extends StatefulWidget {
  const BuyerChatPage(
      {super.key,
      this.personUID,
      this.buyerID,
      this.sellerID,
      this.username,
      this.chats});

  final String? personUID;
  final String? buyerID;
  final String? sellerID;
  final String? username;
  final List<dynamic>? chats;
  static const String routeName = 'Buyer Chat Page';

  @override
  State<BuyerChatPage> createState() => _BuyerChatPageState();
}

class _BuyerChatPageState extends State<BuyerChatPage> {
  @override
  Widget build(BuildContext context) {
    final UserAuth auth = Provider.of<UserAuth>(context);
    final ChatsFirestore chat = Provider.of<ChatsFirestore>(context);
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final personUID = args?['personUID'] ?? '';
    final username = args?['username'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          username ?? '',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<QueryDocumentSnapshot>>(
                stream: auth.currentUser.uid.compareTo(personUID) < 0
                    ? chat.getMessagesInChatStream(
                        auth.currentUser.uid + personUID)
                    : chat.getMessagesInChatStream(
                        personUID + auth.currentUser.uid),
                builder: (context, snapshot) {
                  auth.currentUser.uid.compareTo(personUID) < 0
                      ? chat.markMessagesAsRead(
                          auth.currentUser.uid + personUID,
                          auth.currentUser.uid)
                      : chat.markMessagesAsRead(
                          personUID + auth.currentUser.uid,
                          auth.currentUser.uid);
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      final messages = snapshot.data;
                      return ListView(
                        reverse: true,
                        children: messages?.map((doc) {
                              final message =
                                  doc.data() as Map<String, dynamic>;
                              final isMyMessage =
                                  message['senderID'] == auth.currentUser.uid;
                              return ChatBubble(
                                text: message['messageText'],
                                isMyMessage: isMyMessage,
                              );
                            }).toList() ??
                            [],
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error loading messages'),
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            _buildInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    final UserAuth auth = Provider.of<UserAuth>(context);
    final ChatsFirestore chat = Provider.of<ChatsFirestore>(context);
    final BuyersFirestore buyer = Provider.of<BuyersFirestore>(context);
    final SellerFirestore seller = Provider.of<SellerFirestore>(context);
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final personUID = args?['personUID'];
    final buyerID = args?['buyerID'];
    final sellerID = args?['sellerID'];
    final chats = args?['chats'];
    final TextEditingController messageController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
              controller: messageController,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              if (messageController.text.isNotEmpty) {
                final messageText = messageController.text;
                messageController.clear();
                final chatID = auth.currentUser.uid.compareTo(personUID) < 0
                    ? auth.currentUser.uid + personUID
                    : personUID + auth.currentUser.uid;
                await chat.createMessage(chatID, {
                  'senderID': auth.currentUser.uid,
                  'receiverID': personUID,
                  'messageText': messageText,
                  'timestamp': DateTime.now().millisecondsSinceEpoch,
                  'read': false,
                });
                if (await buyer.isBuyer(auth.currentUser.email ?? '')) {
                  if (!(buyer.buyer?.chats?.contains(personUID) ?? true)) {
                    List<dynamic>? newChats = buyer.buyer?.chats;
                    newChats?.add(personUID);
                    await buyer.updateBuyerData(chats: newChats);
                  } else {
                    List<dynamic>? newChats = buyer.buyer?.chats;
                    newChats?.remove(personUID);
                    newChats?.add(personUID);
                    await buyer.updateBuyerData(chats: newChats);
                  }
                } else {
                  if (!(seller.seller?.chats?.contains(personUID) ?? true)) {
                    List<dynamic>? newChats = seller.seller?.chats;
                    newChats?.add(personUID);
                    await seller.updateSellerData(chats: newChats);
                  } else {
                    List<dynamic>? newChats = seller.seller?.chats;
                    newChats?.remove(personUID);
                    newChats?.add(personUID);
                    await seller.updateSellerData(chats: newChats);
                  }
                }
                if (buyerID != null) {
                  if (await buyer.isBuyer(auth.currentUser.email ?? '')) {
                    if (!(chats.contains(buyer.buyer?.buyerUID) ?? true)) {
                      List<dynamic>? newChats = chats;
                      newChats?.add(buyer.buyer?.buyerUID);
                      await buyer.updateBuyerByID(
                          buyerID: buyerID, chats: newChats);
                    } else {
                      List<dynamic>? newChats = chats;
                      newChats?.remove(buyer.buyer?.buyerUID);
                      newChats?.add(buyer.buyer?.buyerUID);
                      await buyer.updateBuyerByID(
                          buyerID: buyerID, chats: newChats);
                    }
                  } else {
                    if (!(chats.contains(seller.seller?.sellerUID) ?? true)) {
                      List<dynamic>? newChats = chats;
                      newChats?.add(seller.seller?.sellerUID);
                      await buyer.updateBuyerByID(
                          buyerID: buyerID, chats: newChats);
                    } else {
                      List<dynamic>? newChats = chats;
                      newChats?.remove(seller.seller?.sellerUID);
                      newChats?.add(seller.seller?.sellerUID);
                      await buyer.updateBuyerByID(
                          buyerID: buyerID, chats: newChats);
                    }
                  }
                }
                if (sellerID != null) {
                  if (await buyer.isBuyer(auth.currentUser.email ?? '')) {
                    if (!(chats.contains(buyer.buyer?.buyerUID) ?? true)) {
                      List<dynamic>? newChats = chats;
                      newChats?.add(buyer.buyer?.buyerUID);
                      await seller.updateSellerByID(
                          sellerID: sellerID, chats: newChats);
                    } else {
                      List<dynamic>? newChats = chats;
                      newChats?.remove(buyer.buyer?.buyerUID);
                      newChats?.add(buyer.buyer?.buyerUID);
                      await seller.updateSellerByID(
                          sellerID: sellerID, chats: newChats);
                    }
                  } else {
                    if (!(chats.contains(seller.seller?.sellerUID) ?? true)) {
                      List<dynamic>? newChats = chats;
                      newChats?.add(seller.seller?.sellerUID);
                      await seller.updateSellerByID(
                          sellerID: sellerID, chats: newChats);
                    } else {
                      List<dynamic>? newChats = chats;
                      newChats?.remove(seller.seller?.sellerUID);
                      newChats?.add(seller.seller?.sellerUID);
                      await seller.updateSellerByID(
                          sellerID: sellerID, chats: newChats);
                    }
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMyMessage;

  const ChatBubble({
    Key? key,
    required this.text,
    required this.isMyMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final align =
        isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bgColor = isMyMessage ? Colors.deepPurple : Colors.grey;
    final textColor = isMyMessage ? Colors.white : Colors.black;
    final borderRadius = isMyMessage
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: align,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: borderRadius,
            ),
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
