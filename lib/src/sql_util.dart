import 'package:sqlparser/sqlparser.dart';

class SqlUtil {
  static final _sqlEngine = SqlEngine();

  SqlUtil._();

  /// Identifies affected tables in a given SQL statement.
  static Set<String> getAffectedTables(String sql) {
    try {
      return _getAffectedTables(
          _sqlEngine.parse(sql).rootNode as BaseSelectStatement);
    } catch (_) {
      print('Error parsing statement: $sql');
      rethrow;
    }
  }

  static Set<String> _getAffectedTables(AstNode node) {
    if (node is TableReference) return {node.tableName};
    return node.allDescendants
        .fold({}, (prev, e) => prev..addAll(_getAffectedTables(e)));
  }
}
