import 'package:file/memory.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_types/app_types.dart';

void main() {
  const baseUrl = "https://example.com";
  const imageUrl = "/image.png";
  const localImagePath = "image.png";

  setUpAll(() {
    AppImage.init(baseURL: baseUrl, fileSystem: MemoryFileSystem());
  });

  test('initBaseURL', () {
    expect(AppImage.baseURL, baseUrl);
  });

  test('createNetworkImage', () {
    final networkImage = AppNetworkImage.build(imageUrl);
    expect(networkImage.url, "$baseUrl$imageUrl");
    expect(networkImage.baseUrl, baseUrl);
    expect(networkImage.provider is NetworkImage, true);
  });

  test('createCompleteNetworkImage', () {
    final completeNetworkImage = AppCompleteNetworkImage.build(
      imageXS: imageUrl,
      imageSM: imageUrl,
      imageNormal: imageUrl,
    );
    expect(completeNetworkImage.url, "$baseUrl$imageUrl");
    expect(completeNetworkImage.baseUrl, baseUrl);
    expect(completeNetworkImage.providerXS is NetworkImage, true);
    expect(completeNetworkImage.providerSM is NetworkImage, true);
    expect(completeNetworkImage.provider is NetworkImage, true);
  });

  test('createFileImage', () {
    const fileImage = AppFileImage(
      filepath: localImagePath,
      name: localImagePath,
    );
    expect(fileImage.provider is FileImage, true);
    expect(fileImage.filepath, localImagePath);
  });
}
