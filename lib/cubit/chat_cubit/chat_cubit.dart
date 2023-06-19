import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/cubit/chat_cubit/chat_states.dart';
import 'package:social_app/models/message_model/message_model.dart';
import 'package:social_app/shared/components/constants.dart';

class ChatCubit extends Cubit<ChatStates> {
  ChatCubit() : super(ChatInitialState());

  static ChatCubit get(context) => BlocProvider.of(context);
  List<String> chats = [];
  List<MessageModel> messages = [];
  MessageModel? message;

  void getChats() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .snapshots()
        .listen((value) {
      chats = [];
      debugPrint('chats docs length: ${value.docs.length}');
      for (var element in value.docs) {
        debugPrint('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${element.id}');
        chats.add(element.id);
      }
      debugPrint('- chats length : ${chats.length}');

      emit(ChatGetChatsSuccessState());
    });
  }

  void sendMessage({
    required String text,
    required String receiverId,
    required DateTime dateTime,
    required BuildContext context,
  }) async {
    MessageModel messageModel = MessageModel(
      dateTime: dateTime,
      receiverId: receiverId,
      senderId: uId!,
      text: text,
    );
    var firestoreRef = FirebaseFirestore.instance;
    var myMessageRef = firestoreRef
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId);
    var otherMessageRef = firestoreRef
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(uId);
    firestoreRef.runTransaction(
      (transaction) async {
        return transaction.set(myMessageRef, {'exist': true});
      },
    );
    await myMessageRef
        .collection('messages')
        .add(messageModel.toJson())
        .then((value) {
      emit(ChatSendMessageSuccessState());
    }).catchError((error) {
      emit(ChatSendMessageErrorState());
    });
    firestoreRef.runTransaction(
      (transaction) async {
        return transaction.set(myMessageRef, {'exist': true});
      },
    );
    await otherMessageRef
        .collection('messages')
        .add(messageModel.toJson())
        .then((value) {
      // final userToken =
      //     users.firstWhere((user) => user.uId == receiverId).token;

      // FCMHelper.pushChatMessageFCM(
      //   title: '${userModel!.name} sent you a message',
      //   userName: userModel!.name,
      //   context: context,
      //   dateTime: dateTime,
      //   userImage: userModel!.image!,
      //   description: '',
      //   userId: userModel!.uId,
      //   receiverId: receiverId,
      //   userToken: userToken,
      // );
      emit(ChatSendMessageSuccessState());
    }).catchError((error) {
      emit(ChatSendMessageErrorState());
    });
    // /// my message
    //      FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(uId)
    //     .collection('chats')
    //     .doc(receiverId)
    //     .collection('messages')
    //     .add(messageModel.toJson())
    //     .then((value) async {
    //   if (!chats.contains(receiverId)) {
    //     chats.add(receiverId);
    //     await CacheHelper.saveData(key: 'chats', value: chats).then((value) {
    //       chats = [];
    //       chats.addAll(CacheHelper.getListString(key: 'chats'));
    //     });
    //   }
    //   emit(PostSendMessageSuccessState());
    // }).catchError((error) {
    //   emit(PostSendMessageErrorState());
    // });
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(receiverId)
    //     .collection('chats')
    //     .doc(uId)
    //     .collection('messages')
    //     .add(messageModel.toJson())
    //     .then((value) {
    //   final userToken =
    //       users.firstWhere((user) => user.uId == receiverId).token;
    //
    //   FCMHelper.pushChatMessageFCM(
    //     title: '${userModel!.name} sent you a message',
    //     userName: userModel!.name,
    //     context: context,
    //     dateTime: dateTime,
    //     userImage: userModel!.image!,
    //     description: '',
    //     userId: userModel!.uId,
    //     receiverId: receiverId,
    //     userToken: userToken,
    //   );
    //   emit(PostSendMessageSuccessState());
    // }).catchError((error) {
    //   emit(PostSendMessageErrorState());
    // });
  }

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy(
          'dateTime',
          descending: true,
        )
        .snapshots()
        .listen((event) {
      messages = [];
      for (var element in event.docs) {
        messages.add(
          MessageModel.fromJson(element.data()),
        );
      }
      emit(ChatGetMessageSuccessState());
    });
  }

  MessageModel? getLastMessage({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy(
          'dateTime',
        )
        .get()
        .then((value) {
      message = MessageModel.fromJson(value.docs.last.data());

      emit(ChatGetMessageSuccessState());
    }).catchError((error) {
      debugPrint('Error when get last message : $error');
      emit(ChatGetMessageErrorState());
    });
    return message;
  }
}