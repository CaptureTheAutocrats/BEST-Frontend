import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

final _productUploadFormKey = GlobalKey<FormState>();

enum ProductCondition { New, Used }

class ProductUploadPage extends StatefulWidget {
  const ProductUploadPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProductUploadPageState();
}

class _ProductUploadPageState extends State<ProductUploadPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  var _productCondition = ProductCondition.New;

  String _imagePickerText = "Pick an Image";

  Uint8List? _imageBytes;
  String _imageExtension = '';

  @override
  void initState() {
    super.initState();
  }

  void _updateImagePickerText(String newText) {
    setState(() {
      _imagePickerText = newText;
    });
  }

  void _updateImage(String extension, Uint8List imageBytes) {
    setState(() {
      _imageBytes = imageBytes;
      _imageExtension = extension;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.lightBlue,
      centerTitle: true,
      title: Text("Upload a Product"),
    ),
    body: Form(
      key: _productUploadFormKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 16,
          children: [
            GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image == null) {
                  _updateImagePickerText(
                    "Unsuccessful. Kindly pick an image again.",
                  );
                  return;
                }

                final extension = path.extension(image.path);
                final imageBytes = await image.readAsBytes();

                _updateImage(extension, imageBytes);
                _updateImagePickerText("Selected: $image.path");
              },
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!, width: 1.5),
                ),
                child:
                    _imageBytes == null
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 10,
                          children: [
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                            Text(
                              _imagePickerText,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            _imageBytes!,
                            fit: BoxFit.cover,
                            height: 300,
                          ),
                        ),
              ),
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name",
                hintText: "Enter product name",
              ),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                hintText: "Enter product description",
              ),
            ),
            TextFormField(
              controller: _stockController,
              decoration: InputDecoration(
                labelText: "Stock",
                hintText:
                    "Enter the number of products you currently have in stock",
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (stock) {
                if (stock == null || stock.isEmpty) {
                  return "Stock is required";
                }
                if (int.parse(stock) < 1) {
                  return "You cannot list a product without having stock";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUnfocus,
            ),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: "Price",
                hintText: "Enter the listing price for your product",
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <FilteringTextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              validator: (price) {
                if (price == null || price.isEmpty) {
                  return "Price is required";
                }
                if (double.parse(price) < 1) {
                  return "Price cannot be less than 1";
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUnfocus,
            ),
            DropdownButtonFormField(
              value: ProductCondition.New,
              onChanged: (cond) {
                if (cond == null) return;
                _productCondition = cond;
              },
              decoration: InputDecoration(labelText: "Product Condition"),
              items:
                  ProductCondition.values.map((condition) {
                    return DropdownMenuItem<ProductCondition>(
                      value: condition,
                      child: Text(condition.name),
                    );
                  }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                if (!_productUploadFormKey.currentState!.validate()) return;

                final price = double.parse(_priceController.text);
                final stock = int.parse(_stockController.text);

                APIService()
                    .uploadProduct(
                      price: price,
                      stock: stock,
                      name: _nameController.text,
                      description: _descriptionController.text,
                      productCondition: _productCondition.name,
                      base64Image: base64Encode(_imageBytes as List<int>),
                      imageExtension: _imageExtension,
                    )
                    .then((err) {
                      if (kDebugMode) print(err);
                    })
                    .catchError((err) {
                      if (kDebugMode) print(err);
                    });
              },
              child: Text("Upload"),
            ),
          ],
        ),
      ),
    ),
  );
}
