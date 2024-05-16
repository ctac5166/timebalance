import 'package:objectbox/objectbox.dart';

@Entity()
class WallPaperEntity {
  @Id()
  int id;
  String fullpathToFile;
  String urlToDownload;

  WallPaperEntity({
    this.id = 0,
    required this.fullpathToFile,
    required this.urlToDownload,
  });
}
