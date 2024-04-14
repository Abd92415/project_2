import 'package:flutter/material.dart';
import 'package:graduation_project/services/Firebase/buyer_firestore.dart';
import 'package:graduation_project/services/Firebase/chat_firestore.dart';
import 'package:graduation_project/services/Firebase/user_auth.dart';
import 'package:graduation_project/views/home/buyerHome/component/pageNav/buyer_chat_page.dart';
import 'package:provider/provider.dart';

class BuyerChatsPage extends StatefulWidget {
  const BuyerChatsPage({super.key});

  static const String routeName = 'Chats Page';

  @override
  State<BuyerChatsPage> createState() => _BuyerChatsPageState();
}

class _BuyerChatsPageState extends State<BuyerChatsPage> {
  @override
  Widget build(BuildContext context) {
    final UserAuth auth = Provider.of<UserAuth>(context);
    final BuyersFirestore buyer = Provider.of<BuyersFirestore>(context);
    final ChatsFirestore chat = Provider.of<ChatsFirestore>(context);

    List<dynamic> chatUserIds = buyer.buyer?.chats ?? [];

    Future<dynamic> getPersonByID({required String id}) async {
      try {
        final personData = await buyer.getPersonByID(id: id);
        return personData;
      } catch (error) {
        // ignore: avoid_print
        print("Error fetching person data: $error");
        return null;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: chatUserIds.length,
          itemBuilder: (BuildContext context, int index) {
            final chatUserId = chatUserIds[chatUserIds.length - 1 - index];
            return FutureBuilder(
              future: getPersonByID(id: chatUserId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    final person = snapshot.data;
                    return FutureBuilder(
                      future: auth.currentUser.uid.compareTo(chatUserId) < 0
                          ? chat.getLastMessageInChat(
                              auth.currentUser.uid + chatUserId)
                          : chat.getLastMessageInChat(
                              chatUserId + auth.currentUser.uid),
                      builder: (context, messageSnapshot) {
                        if (messageSnapshot.connectionState ==
                            ConnectionState.done) {
                          return Card(
                            color: Colors.deepPurple[300],
                            elevation: 4,
                            margin: const EdgeInsets.all(8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              leading: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Colors.white,
                                    backgroundImage: person.profilePicture !=
                                                '' &&
                                            person.profilePicture != null
                                        ? NetworkImage(person.profilePicture)
                                        : const AssetImage(
                                                'assets/images/defaultAvatar.png')
                                            as ImageProvider,
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: FutureBuilder(
                                      future: auth.currentUser.uid
                                                  .compareTo(chatUserId) <
                                              0
                                          ? chat.calculateUnreadMessagesCount(
                                              auth.currentUser.uid + chatUserId,
                                              auth.currentUser.uid)
                                          : chat.calculateUnreadMessagesCount(
                                              chatUserId + auth.currentUser.uid,
                                              auth.currentUser.uid),
                                      builder: (context, unreadCountSnapshot) {
                                        if (unreadCountSnapshot
                                                .connectionState ==
                                            ConnectionState.done) {
                                          final unreadMessagesCount =
                                              unreadCountSnapshot.data as int;
                                          return unreadMessagesCount > 0
                                              ? Container(
                                                  padding:
                                                      const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.red[300],
                                                  ),
                                                  child: Text(
                                                    unreadMessagesCount
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : Container();
                                        } else {
                                          return const Text('Loading...');
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                person.username,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: FutureBuilder(
                                future:
                                    auth.currentUser.uid.compareTo(chatUserId) <
                                            0
                                        ? chat.getLastMessageInChat(
                                            auth.currentUser.uid + chatUserId)
                                        : chat.getLastMessageInChat(
                                            chatUserId + auth.currentUser.uid),
                                builder: (context, messageSnapshot) {
                                  if (messageSnapshot.connectionState ==
                                      ConnectionState.done) {
                                    final lastMessage = messageSnapshot.data;
                                    return Text(
                                      lastMessage != null
                                          ? lastMessage['messageText']
                                              .toString()
                                          : 'No messages',
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    );
                                  } else if (messageSnapshot.hasError) {
                                    return const Text(
                                        'Error loading chat data');
                                  } else {
                                    return const Text('Loading...');
                                  }
                                },
                              ),
                              onTap: () async {
                                Navigator.pushNamed(
                                  context,
                                  BuyerChatPage.routeName,
                                  arguments:
                                      await buyer.isBuyer(person?.email ?? '')
                                          ? {
                                              'personUID': person.buyerUID,
                                              'buyerID': person.buyerId,
                                              'username': person.username,
                                              'chats': person.chats,
                                            }
                                          : {
                                              'personUID': person.sellerUID,
                                              'sellerID': person.sellerId,
                                              'username': person.username,
                                              'chats': person.chats,
                                            },
                                );
                              },
                            ),
                          );
                        } else if (messageSnapshot.hasError) {
                          return const ListTile(
                            title: Text('Error loading chat data'),
                          );
                        } else {
                          return const ListTile(
                            title: Text('Loading...'),
                          );
                        }
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const ListTile(
                      title: Text('Error loading chat data'),
                    );
                  }
                }
                return const ListTile(
                  title: Text('Loading...'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
