import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tbsosick/data/models/card_details_model.dart';
import 'package:intl/intl.dart';

class PdfService {
  Future<Uint8List?> _downloadImageBytes(String url) async {
    try {
      final dio = Dio();
      final response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.data != null) {
        return Uint8List.fromList(response.data!);
      }
    } catch (e) {
      // Ignore errors so PDF generation can proceed
    }
    return null;
  }

  Future<File> generatePreferenceCardPdf(
    PreferenceCardDetailsModel card,
    String savePath,
  ) async {
    final pdf = pw.Document();

    final List<pw.MemoryImage> pdfImages = [];
    for (final imageUrl in card.photoLibrary) {
      if (imageUrl.isNotEmpty) {
        final bytes = await _downloadImageBytes(imageUrl);
        if (bytes != null) {
          pdfImages.add(pw.MemoryImage(bytes));
        }
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(card),
            pw.SizedBox(height: 20),
            _buildSurgeonInfo(card),
            pw.SizedBox(height: 10),
            _buildSection('Medication', card.medication),
            _buildListSection(
              'Supplies',
              card.supplies.map((e) => "${e.name} (Qty: ${e.quantity})").toList(),
            ),
            _buildListSection(
              'Sutures',
              card.sutures.map((e) => "${e.name} (Qty: ${e.quantity})").toList(),
            ),
            _buildSection('Instruments', card.instruments),
            _buildSection('Positioning Equipment', card.positioningEquipment),
            _buildSection('Prepping / Shaving', card.prepping),
            _buildSection('Workflow', card.workflow),
            _buildSection('Key Notes', card.keyNotes),
            pw.SizedBox(height: 10),
            _buildPhotoLibrarySection(pdfImages),
            pw.SizedBox(height: 20),
            _buildFooter(card),
          ];
        },
      ),
    );

    final file = File(savePath);
    final parentDir = file.parent;
    if (!await parentDir.exists()) {
      await parentDir.create(recursive: true);
    }
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  pw.Widget _buildHeader(PreferenceCardDetailsModel card) {
    final primaryColor = PdfColor.fromInt(0xFF6C36B2);
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: primaryColor, width: 2),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                card.cardTitle,
                style: pw.TextStyle(
                  fontSize: 26,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Preference Card Details',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey700,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Updated: ${DateFormat('yyyy-MM-dd').format(card.updatedAt)}',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSurgeonInfo(PreferenceCardDetailsModel card) {
    final primaryColor = PdfColor.fromInt(0xFF6C36B2);
    final lightBg = PdfColor.fromInt(0xFFF5F3FF);
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      margin: const pw.EdgeInsets.only(bottom: 15),
      decoration: pw.BoxDecoration(
        color: lightBg,
        border: pw.Border(
          left: pw.BorderSide(color: primaryColor, width: 4),
          top: const pw.BorderSide(color: PdfColors.grey300, width: 0.5),
          bottom: const pw.BorderSide(color: PdfColors.grey300, width: 0.5),
          right: const pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Surgeon Information',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: primaryColor,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            children: [
              pw.TableRow(
                children: [
                  _buildTableLabel('Name'),
                  _buildTableValue(card.surgeon.fullName),
                  _buildTableLabel('Specialty'),
                  _buildTableValue(card.surgeon.specialty),
                ],
              ),
              pw.TableRow(
                children: [
                  _buildTableLabel('Contact'),
                  _buildTableValue(card.surgeon.contactNumber),
                  _buildTableLabel('Music Preference'),
                  _buildTableValue(card.surgeon.musicPreference),
                ],
              ),
              pw.TableRow(
                children: [
                  _buildTableLabel('Hand Preference'),
                  _buildTableValue(card.surgeon.handPreference),
                  _buildTableLabel(''),
                  _buildTableValue(''),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTableLabel(String text) {
    if (text.isEmpty) return pw.SizedBox.shrink();
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Text(
        '$text:',
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 10,
          color: PdfColors.grey800,
        ),
      ),
    );
  }

  pw.Widget _buildTableValue(String text) {
    if (text.isEmpty) return pw.SizedBox.shrink();
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Text(
        text,
        style: const pw.TextStyle(
          fontSize: 10,
          color: PdfColors.black,
        ),
      ),
    );
  }

  pw.Widget _buildSection(String title, String content) {
    if (content.isEmpty) return pw.Container();
    final primaryColor = PdfColor.fromInt(0xFF6C36B2);
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 3,
                height: 14,
                color: primaryColor,
              ),
              pw.SizedBox(width: 6),
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 9),
            child: pw.Text(
              content,
              style: const pw.TextStyle(fontSize: 11, color: PdfColors.black),
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Divider(color: PdfColors.grey200, thickness: 0.5),
        ],
      ),
    );
  }

  pw.Widget _buildListSection(String title, List<String> items) {
    if (items.isEmpty) return pw.Container();
    final primaryColor = PdfColor.fromInt(0xFF6C36B2);
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 3,
                height: 14,
                color: primaryColor,
              ),
              pw.SizedBox(width: 6),
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 9),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: items.map(
                (item) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Bullet(
                    text: item,
                    style: const pw.TextStyle(
                      fontSize: 11,
                      color: PdfColors.black,
                    ),
                    bulletColor: primaryColor,
                  ),
                ),
              ).toList(),
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Divider(color: PdfColors.grey200, thickness: 0.5),
        ],
      ),
    );
  }

  pw.Widget _buildPhotoLibrarySection(List<pw.MemoryImage> images) {
    if (images.isEmpty) return pw.Container();
    final primaryColor = PdfColor.fromInt(0xFF6C36B2);
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 3,
                height: 14,
                color: primaryColor,
              ),
              pw.SizedBox(width: 6),
              pw.Text(
                'Photo Library',
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 9),
            child: pw.Wrap(
              spacing: 12,
              runSpacing: 12,
              children: images.map((image) {
                return pw.Container(
                  width: 140,
                  height: 140,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                  ),
                  child: pw.ClipRRect(
                    horizontalRadius: 5,
                    verticalRadius: 5,
                    child: pw.Image(image, fit: pw.BoxFit.cover),
                  ),
                );
              }).toList(),
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Divider(color: PdfColors.grey200, thickness: 0.5),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(PreferenceCardDetailsModel card) {
    final primaryColor = PdfColor.fromInt(0xFF6C36B2);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.SizedBox(height: 15),
        pw.Text(
          'Generated by SmrtScrub',
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            color: primaryColor,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          'https://smrtscrub.app',
          style: const pw.TextStyle(
            fontSize: 8,
            color: PdfColors.grey500,
          ),
        ),
      ],
    );
  }
}
