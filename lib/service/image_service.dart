import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  Future<String?> pickAndSaveImage() async {
    // pede permissão em runtime
    final status = await Permission.photos.request();
    if (!status.isGranted) return null;

    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null; // usuário cancelou

    // pegar pasta local do app
    final appDir = await getApplicationDocumentsDirectory();

    // criar caminho de destino
    final fileName = path.basename(image.path);
    final savedImage = await File(image.path).copy('${appDir.path}/$fileName');

    return savedImage.path; // retorna o caminho local
  }
}
