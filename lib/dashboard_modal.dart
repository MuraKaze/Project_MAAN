import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DashboardModal {
  static Future<List<dynamic>> _loadQuotes() async {
    String data = await rootBundle.loadString('lib/assets/text/quotes.json');
    return json.decode(data);
  }

  static Future<String> _getRandomImage() async {
    int imageCount = 8;
    int randomIndex = Random().nextInt(imageCount) + 1;
    return 'lib/assets/images/image$randomIndex.jpg';
  }

  static Future<String> _getRandomQuote() async {
    List<dynamic> quotes = await _loadQuotes();
    int randomIndex = Random().nextInt(quotes.length);
    return quotes[randomIndex]['quote'];
  }

  static Future<void> openRandomModal(BuildContext context) async {
    String imageUrl = await _getRandomImage();
    String quote = await _getRandomQuote();

    // ignore: use_build_context_synchronously
    showModalBottomSheet(
      context: context,
      builder: (_) => RandomModalWidget(imageUrl, quote),
    );
  }

  static void openUploadModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => const UploadModalWidget(),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class RandomModalWidget extends StatelessWidget {
  final String imageUrl;
  final String quote;

  const RandomModalWidget(this.imageUrl, this.quote, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8, // 80% of the screen width
      child: SizedBox(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Text(
              quote,
              textAlign: TextAlign.center, // Adjust alignment as needed
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              maxLines: null, // Set to null for multiline text
            ),
          ],
        ),
      ),
    );
  }
}

class UploadModalWidget extends StatefulWidget {
  const UploadModalWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UploadModalWidgetState createState() => _UploadModalWidgetState();
}

class _UploadModalWidgetState extends State<UploadModalWidget> {
  bool _isTextSelected = true;
  bool _isImageSelected = false;

  String? _textValue;
  List<File> _selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isTextSelected = true;
                      _isImageSelected = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            _isTextSelected ? Colors.blue : Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        'Text',
                        style: TextStyle(
                          color: _isTextSelected ? Colors.blue : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isTextSelected = false;
                      _isImageSelected = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _isImageSelected
                            ? Colors.green
                            : Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        'Image',
                        style: TextStyle(
                          color: _isImageSelected ? Colors.green : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          _isTextSelected ? _textUploadWidget() : _imageUploadWidget(),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: _isTextSelected && (_textValue != null)
                ? _submitText
                : _isImageSelected && (_selectedImages.isNotEmpty)
                    ? _submitImage
                    : null,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Widget _textUploadWidget() {
    return TextField(
      onChanged: (value) {
        setState(() {
          _textValue = value;
        });
      },
      decoration: const InputDecoration(
        hintText: 'Enter text here...',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _imageUploadWidget() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _selectImages,
          child: const Text('Select Images'),
        ),
        const SizedBox(
          height: 10,
        ),
        Text('Selected Images: ${_selectedImages.length}'),
      ],
    );
  }

  void _selectImages() async {
    // Implement image selection logic
    // This example uses the image_picker package for selecting images
    // Make sure to add the image_picker dependency in your pubspec.yaml

    // Import the necessary package
    // import 'package:image_picker/image_picker.dart';

    final ImagePicker picker = ImagePicker();

    try {
      // Get images from the gallery
      // ignore: unnecessary_nullable_for_final_variable_declarations
      final List<XFile>? images = await picker.pickMultiImage();

      if (images != null) {
        // Handle the selected images
        List<File> selectedFiles = [];
        for (var image in images) {
          selectedFiles.add(File(image.path));
        }

        // Update state with the selected images
        setState(() {
          _selectedImages = selectedFiles;
        });
      }
    } catch (e) {
      // Handle exceptions, if any
      print('Error selecting images: $e');
    }
  }

  void _submitText() async {
    if (_textValue != null && _textValue!.isNotEmpty) {
      try {
        // Load existing quotes.json data
        String data = await rootBundle.loadString('assets/text/quotes.json');
        List<dynamic> quotes = json.decode(data);

        // Add new text to quotes
        quotes.add({'quote': _textValue});

        // Convert updated quotes list to JSON
        String jsonData = json.encode(quotes);

        // Write updated quotes back to quotes.json
        await File('lib/assets/text/quotes.json').writeAsString(jsonData);

        // Perform any additional actions after text submission
      } catch (e) {
        // Handle exceptions, if any
        print('Error submitting text: $e');
      }
    }
  }

  void _submitImage() async {
    if (_selectedImages.isNotEmpty) {
      try {
        // Store selected images to lib/assets/images
        for (var imageFile in _selectedImages) {
          // Rename images if needed
          // Implement logic to rename images or maintain their names

          // Save images to the desired folder
          String imagePath =
              'lib/assets/images/${DateTime.now().millisecondsSinceEpoch}.jpg';
          await imageFile.copy(imagePath);

          // Perform any additional actions after image submission
        }
      } catch (e) {
        // Handle exceptions, if any
        print('Error submitting images: $e');
      }
    }
  }
}
