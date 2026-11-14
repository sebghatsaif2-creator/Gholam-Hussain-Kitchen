String persianDigits(Object value) {
  const digits = '۰۱۲۳۴۵۶۷۸۹';
  return value.toString().replaceAllMapped(RegExp(r'[0-9]'), (match) => digits[int.parse(match[0]!) ]);
}
