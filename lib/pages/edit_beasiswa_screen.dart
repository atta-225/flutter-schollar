import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBeasiswaScreen extends StatefulWidget {
  final String docId;
  final String oldTitle;
  final String oldDesc;
  final String oldDetail;
  final String oldRegion;
  final String oldImageUrl;

  const EditBeasiswaScreen({
    super.key,
    required this.docId,
    required this.oldTitle,
    required this.oldDesc,
    required this.oldDetail,
    required this.oldRegion,
    required this.oldImageUrl,
  });

  @override
  State<EditBeasiswaScreen> createState() => _EditBeasiswaScreenState();
}

class _EditBeasiswaScreenState extends State<EditBeasiswaScreen> {
  late TextEditingController titleController;
  late TextEditingController detailController;

  String selectedRegion = 'Kalsel';
  bool isLoading = false;

  final List<String> regions = [
    'Kalsel',
    'Kalbar',
    'Kaltim',
    'Kalteng',
  ];

  @override
  void initState() {
    super.initState();
    selectedRegion =
        widget.oldRegion.isEmpty ? 'Kalsel' : widget.oldRegion;

    titleController = TextEditingController(text: widget.oldTitle);
    detailController = TextEditingController(
      text: widget.oldDetail.isNotEmpty ? widget.oldDetail : widget.oldDesc,
    );
  }

  Future<void> saveData() async {
    setState(() => isLoading = true);

    await FirebaseFirestore.instance
        .collection('beasiswa')
        .doc(widget.docId)
        .update({
      'title': titleController.text.trim(),
      'desc': detailController.text.trim(),
      'detail': detailController.text.trim(),
      'region': selectedRegion,
      'imageUrl': widget.oldImageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    setState(() => isLoading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF88),
              Color(0xFFEFFFF6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, size: 28),
                    ),
                    const SizedBox(width: 18),
                    const Text(
                      'Edit News',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.more_vert),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Category',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Wrap(
                          spacing: 18,
                          runSpacing: 4,
                          children: regions.map((region) {
                            return SizedBox(
                              width: 70,
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: region,
                                    groupValue: selectedRegion,
                                    activeColor: const Color(0xFF006B5F),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedRegion = value!;
                                      });
                                    },
                                  ),
                                  Text(
                                    region,
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'Edit Name',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),

                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          'Edit Photo',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: widget.oldImageUrl.isNotEmpty
                              ? Image.network(
                                  widget.oldImageUrl,
                                  width: 82,
                                  height: 104,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 82,
                                  height: 104,
                                  color: const Color(0xFFFFE9A6),
                                  child: const Icon(
                                    Icons.school,
                                    color: Color(0xFF006B5F),
                                    size: 42,
                                  ),
                                ),
                        ),

                        const SizedBox(height: 22),

                        const Text(
                          'Edit Information',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),

                        TextField(
                          controller: detailController,
                          maxLines: 6,
                          decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 22),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : saveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B6B52),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(isLoading ? 'saving...' : 'save'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}