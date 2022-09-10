import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';
import '../../logs/logger.dart';
import '../models/enum.dart';
import '../models/team.dart';

part 'answer_quiz_state.dart';

class AnswerQuizCubit extends Cubit<AnswerQuizState> {
  AnswerQuizCubit() : super(const InitialPhase(''));
  Socket? _clientSocket;
  final List<Team> _listInfor = [];
  String _addr = '';
  int _currentId = 0;

  final Map<ButtonType, String> _jsonListButton = {
    ButtonType.a: '{"type":${DataType.button.index},"button":"a"}',
    ButtonType.b: '{"type":${DataType.button.index},"button":"b"}',
    ButtonType.c: '{"type":${DataType.button.index},"button":"c"}',
    ButtonType.d: '{"type":${DataType.button.index},"button":"d"}',
    ButtonType.star: '{"type":${DataType.button.index},"button":"star"}',
    ButtonType.bell: '{"type":${DataType.button.index},"button":"bell"}'
  };

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _addr = prefs.getString('addr') ?? addr;
    emit(InitialPhase(_addr));
    _setupConnection();
  }

  void disconnect() {
    if (_clientSocket != null) {
      _clientSocket!.close();
      _clientSocket!.destroy();
      _clientSocket = null;
      logger.i('disconnect');
    }
  }

  void _setupConnection() {
    Socket.connect(_addr, port, timeout: const Duration(seconds: 20)).then(
      (socket) {
        _clientSocket = socket;
        logger.i('Connect to server success');
        introProcess(_currentId);
        socket.listen(
          (onData) {
            final data = String.fromCharCodes(onData).trim();
            logger.i(data);
            _processData(data);
          },
          onDone: _onDone,
          onError: _onError,
        );
      },
    ).catchError(
      (e) {
        logger.e(e.message);
        if (e.message.toString().contains("Connection timed out")) {
          _setupConnection();
        }
      },
    );
  }

  void _onDone() {
    logger.i("Connection has terminated.");
    _setupConnection();
  }

  void _onError(e) {
    logger.e("onError: ${e.message}");
  }

  void _processData(String json) {
    Map<String, dynamic> jsonObject = jsonDecode(json);

    int type = jsonObject['type'];
    switch (DataType.values[type]) {
      case DataType.button:
        final buttonType = jsonObject['button'];
        if (state is! OnGoingPhase) {
          logger.e(
              "ClickButton expect on going phase but current phase is ${state.runtimeType}");
          return;
        }
        emit((state as OnGoingPhase)
            .copyWith(buttonClicked: _stringToButtonType(buttonType)));
        break;
      case DataType.intro:
        if (jsonObject['buc'] == 0) {
          if (jsonObject['content'] != null) {
            if (_listInfor.isNotEmpty) _listInfor.clear();
            jsonObject['content'].forEach(
              (v) {
                _listInfor.add(Team.fromMap(v));
              },
            );
            emit(IntroducePhase(teams: _listInfor));
          }
        } else {
          emit(const OnGoingPhase(isStarted: false, questionNumber: 1));
        }
        break;
      case DataType.start:
        int time = jsonObject['time']?.toInt() ?? 0;
        emit(
          OnGoingPhase(
            isStarted: time > 0,
            questionNumber: jsonObject['questionNumber'],
          ),
        );
        break;
      default:
        logger.e("unexpected type");
    }
  }

  ButtonType _stringToButtonType(String button) {
    for (var item in ButtonType.values) {
      if (item.toString() == "ButtonType.${button.toLowerCase()}") {
        return item;
      }
    }
    return ButtonType.none;
  }

  void sendMessage(String msg) {
    if (_clientSocket != null) {
      logger.d(msg);
      _clientSocket!.write("$msg\r");
    }
  }

  void clickOn(ButtonType type) {
    if (state is! OnGoingPhase) {
      logger.e(
          "ClickButton expect on going phase but current phase is ${state.runtimeType}");
      return;
    }

    ButtonType prevClicked = (state as OnGoingPhase).buttonClicked;
    if (prevClicked == type) return;

    switch (type) {
      case ButtonType.a:
        sendMessage(_jsonListButton[ButtonType.a]!);
        break;
      case ButtonType.b:
        sendMessage(_jsonListButton[ButtonType.b]!);
        break;
      case ButtonType.c:
        sendMessage(_jsonListButton[ButtonType.c]!);
        break;
      case ButtonType.d:
        sendMessage(_jsonListButton[ButtonType.d]!);
        break;
      case ButtonType.star:
        sendMessage(_jsonListButton[ButtonType.star]!);
        break;
      case ButtonType.bell:
        sendMessage(_jsonListButton[ButtonType.bell]!);
        break;
      default:
        logger.e("unexpected type of button");
    }
  }

  void introProcess(int id) {
    sendMessage('{"type":${DataType.intro.index},"buc":$id}');
    _currentId = id;
  }
}
