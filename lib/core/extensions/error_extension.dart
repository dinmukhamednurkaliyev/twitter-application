extension ErrorFormatting on Object {
  String toFormattedString() {
    final message = toString();
    const prefix = 'Exception: ';

    if (message.startsWith(prefix)) {
      return message.substring(prefix.length);
    }

    return message;
  }
}
