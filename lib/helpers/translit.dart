class Translit {
  final _transliteratedSymbol = <String, String>{
    'А': 'A',
    'Б': 'B',
    'В': 'V',
    'Г': 'G',
    'Д': 'D',
    'Е': 'E',
    'З': 'Z',
    'И': 'I',
    'Й': 'Y',
    'К': 'K',
    'Л': 'L',
    'М': 'M',
    'Н': 'N',
    'О': 'O',
    'П': 'P',
    'Р': 'R',
    'С': 'S',
    'Т': 'T',
    'У': 'U',
    'Ф': 'F',
    'Х': 'H',
    'Ц': 'C',
    'Ы': 'Y',
    'а': 'a',
    'б': 'b',
    'в': 'v',
    'г': 'g',
    'д': 'd',
    'е': 'e',
    'з': 'z',
    'и': 'i',
    'й': 'y',
    'к': 'k',
    'л': 'l',
    'м': 'm',
    'н': 'n',
    'о': 'o',
    'п': 'p',
    'р': 'r',
    'с': 's',
    'т': 't',
    'у': 'u',
    'ф': 'f',
    'х': 'h',
    'ц': 'c',
    'ы': 'y',
    "'": '',
    '"': '',
  };

  final _complicatedSymbols = <String, String>{
    'Ё': 'Yo',
    'Ж': 'J',
    'Щ': 'Sh',
    'Ш': 'Sh',
    'Ч': 'Ch',
    'Э': "E",
    'Ю': 'Yu',
    'Я': 'Ya',
    'ё': 'yo',
    'ж': 'j',
    'щ': 'sh',
    'ш': 'sh',
    'ч': 'ch',
    'э': "e",
    'ъ': '',
    'ь': "",
    'ю': 'yu',
    'я': 'ya',
  };

  /// Method for converting from translit for the [source] value
  String unTranslit({required String source}) {
    if (source.isEmpty) return source;

    final regExp = RegExp('([a-z]+)', caseSensitive: false, multiLine: true);

    if (!regExp.hasMatch(source)) return source;

    final sourceSymbols = <String>[];
    final unTranslit = <String>[];
    final deTransliteratedSymbol = <String, String>{};

    _complicatedSymbols.forEach((key, value) {
      source = source.replaceAll(value, key);
    });

    sourceSymbols.addAll(source.split(''));

    _transliteratedSymbol.forEach((key, value) {
      deTransliteratedSymbol[value] = key;
    });

    for (final element in sourceSymbols) {
      final transElement = deTransliteratedSymbol.containsKey(element)
          ? deTransliteratedSymbol[element] ?? ''
          : element;
      unTranslit.add(transElement);
    }

    return unTranslit.join();
  }

  /// Method for converting to translit for the [source] value
  String toTranslit({required String source}) {
    if (source.isEmpty) return source;

    final regExp = RegExp(
      '([а-я]+)',
      caseSensitive: false,
      multiLine: true,
    );

    if (!regExp.hasMatch(source)) return source;

    final translit = <String>[];
    final sourceSymbols = <String>[...source.split('')];

    _transliteratedSymbol.addAll(_complicatedSymbols);

    for (final element in sourceSymbols) {
      final transElement = _transliteratedSymbol.containsKey(element)
          ? _transliteratedSymbol[element] ?? ''
          : element;
      translit.add(transElement);
    }

    return translit.join();
  }
}
