/** 
 * pour arrondir un nombre 
 * */
String arrondir(String valeur, {int limit = 3}) {
  final vls = valeur.split('.');
  final res = vls[0] + "," + vls[1].substring(0, limit);
  return res;
}
