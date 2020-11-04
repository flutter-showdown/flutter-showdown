class Parser {
  static String toId(String s) {
    return s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');
  }

  static List<String> parseRoomMessage(String text) {
    //if the room is lobby or global. MESSAGE cannot start with >
    String roomId = 'lobby';

    if (text.startsWith('>')) {
      final int nlIdx = text.indexOf('\n');

      roomId = text.substring(1, nlIdx);
      text = text.substring(nlIdx + 1);
    }
    return [roomId, text];
  }

  static List<String> parseLine(String line) {
    if (!line.startsWith('|')) {
      return ['', line];
    } else if (line == '|') {
      return ['done'];
    }

    final int index = line.indexOf('|', 1);
    final String cmd = line.substring(1, index);

    switch (cmd) {
      case 'chatmsg':
      case 'chatmsg-raw':
      case 'raw':
      case 'error':
      case 'html':
      case 'inactive':
      case 'inactiveoff':
      case 'warning':
      case 'fieldhtml':
      case 'contolshtml':
      case 'bigerror':
      case 'debug':
      case 'tier':
      case 'challstr':
      case 'popup':
      case '':
        return [cmd, line.substring(index + 1)];
      case 'c':
      case 'chat':
      case 'uhtml':
      case 'uhtmlchange':
      case 'queryresponse':
        final int index2 = line.indexOf('|', index + 1);

        return [
          cmd,
          line.substring(index + 1, index2),
          line.substring(index2 + 1)
        ];
      case 'c:':
      case 'pm':
        final int index2 = line.indexOf('|', index + 1);
        final int index3 = line.indexOf('|', index2 + 1);

        return [
          cmd,
          line.substring(index + 1, index2),
          line.substring(index2 + 1, index3),
          line.substring(index3 + 1)
        ];
    }
    return line.substring(1).split('|');
  }

  static List<String> parseName(String text) {
    String group = ' ';

    if (RegExp(r'^[^A-Za-z0-9]').firstMatch(text) != null) {
      group = text[0];
      text = text.substring(1);
    }

    String name = text;
    String status = '';
    final int atIndex = name.indexOf('@');

    if (atIndex > 0) {
      name = text.substring(0, atIndex);
      status = text.substring(atIndex + 1);
    }
    return [name, group, status];
  }
}
