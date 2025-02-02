import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:timebalance/data/models/pomodoroShemeModel.dart';
import 'package:timebalance/objectbox.g.dart';

class ObjectBox {
  late final Store store;

  ObjectBox._create(this.store);

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store =
        openStore(directory: p.join(docsDir.path, "obx-timebalance-12052024"));
    return ObjectBox._create(store);
  }
}
