import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../multi_image_picker_view.dart';

/// Controller for the [MultiImagePickerView].
/// This controller contains all them images that the user has selected.
class MultiImagePickerController with ChangeNotifier {
  final List<String> allowedImageTypes;
  final int maxImages;

  MultiImagePickerController({this.allowedImageTypes = const ['png', 'jpeg', 'jpg'], this.maxImages = 10, Iterable<ImageFile>? images}) {
    if (images != null) {
      this.images = List.from(images);
    } else {
      this.images = [];
    }
  }

  late final List<ImageFile> images;

  /// Returns [Iterable] of [ImageFile] that user has selected.

  /// Returns true if user has selected no images.
  bool get hasNoImages => images.isEmpty;

  /// manually pick images. i.e. on click on external button.
  /// this method open Image picking window.
  /// It returns [Future] of [bool], true if user has selected images.
  Future<bool> pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: allowedImageTypes);
    if (result != null && result.files.isNotEmpty) {
      _addImages(result.files
          .where((e) => e.extension != null && allowedImageTypes.contains(e.extension?.toLowerCase()))
          .map((e) => ImageFile(name: e.name, extension: e.extension!, bytes: e.bytes, path: !kIsWeb ? e.path : null)));
      notifyListeners();
      return true;
    }
    return false;
  }

  void _addImages(Iterable<ImageFile> images) {
    int i = 0;
    while (images.length < maxImages && images.length > i) {
      this.images.add(images.elementAt(i));
      i++;
    }
  }

  /// Manually re-order image, i.e. move image from one position to another position.
  void reOrderImage(int oldIndex, int newIndex, {bool notify = true}) {
    final oldItem = images.removeAt(oldIndex);
    oldItem.size;
    images.insert(newIndex, oldItem);
    if (notify) {
      notifyListeners();
    }
  }

  /// Manually remove image from list.
  void removeImage(ImageFile imageFile) {
    images.remove(imageFile);
    notifyListeners();
  }

  @override
  void dispose() {
    print(images);
    print('dispose');
    super.dispose();
    print(images);
  }
}
