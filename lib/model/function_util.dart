class FunctionUtil {
  String convertDDMMYYYToYYYYMMDD(String date) {
    var arrDate = date.split('/');
    //print(arrDate);
    var dateRevert = new List.from(arrDate.reversed);
    //print(dateRevert);
    return dateRevert[0] + '-' + dateRevert[1] + '-' + dateRevert[2];
  }
}
