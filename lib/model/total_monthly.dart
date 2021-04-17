import 'dart:ffi';

class TotalMonthly {
  dynamic total;
  dynamic month;

  TotalMonthly(this.total, this.month);

  TotalMonthly.fromJson(Map<String, dynamic> json)
      : total = json['total'],
        month = json['_month'];
  Map<String, dynamic> toJson() => {'total': total, 'month': month};
}
