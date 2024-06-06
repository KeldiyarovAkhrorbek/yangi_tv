String k_m_b_generator(int num) {
  if (num > 999999 && num < 999999999) {
    return "${(num / 1000000).toStringAsFixed(0)} M";
  } else if (num > 999999999) {
    return "${(num / 1000000000).toStringAsFixed(0)} B";
  } else {
    return num.toString();
  }
}
