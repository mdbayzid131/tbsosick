import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:tbsosick/data/models/card_details_model.dart';
import 'package:intl/intl.dart';

class PdfService {
  Future<File> generatePreferenceCardPdf(
    PreferenceCardDetailsModel card,
  ) async {
    final pdf = pw.Document();

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
              card.supplies.map((e) => e.name).toList(),
            ),
            _buildListSection(
              'Sutures',
              card.sutures.map((e) => e.name).toList(),
            ),
            _buildSection('Instruments', card.instruments),
            _buildSection('Positioning', card.positioningEquipment),
            _buildSection('Prepping / Shaving', card.prepping),
            _buildSection('Workflow', card.workflow),
            _buildSection('Key Notes', card.keyNotes),
            pw.SizedBox(height: 20),
            _buildFooter(card),
          ];
        },
      ),
    );

    Directory directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory =
            await getExternalStorageDirectory() ??
            await getApplicationDocumentsDirectory();
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final fileName = 'preference_card_${card.id}.pdf';
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  pw.Widget _buildHeader(PreferenceCardDetailsModel card) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          card.cardTitle,
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'Updated: ${DateFormat('yyyy-MM-dd').format(card.updatedAt)}',
          style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey),
        ),
        pw.Divider(),
      ],
    );
  }

  pw.Widget _buildSurgeonInfo(PreferenceCardDetailsModel card) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      margin: const pw.EdgeInsets.only(bottom: 10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Surgeon Information',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 5),
          _buildInfoRow('Name', card.surgeon.fullName),
          _buildInfoRow('Specialty', card.surgeon.specialty),
          _buildInfoRow('Contact', card.surgeon.contactNumber),
          _buildInfoRow('Music', card.surgeon.musicPreference),
          _buildInfoRow('Hand', card.surgeon.handPreference),
        ],
      ),
    );
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 2),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSection(String title, String content) {
    if (content.isEmpty) return pw.Container();
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          pw.Text(content, style: const pw.TextStyle(fontSize: 12)),
          pw.SizedBox(height: 5),
          pw.Divider(color: PdfColors.grey300),
        ],
      ),
    );
  }

  pw.Widget _buildListSection(String title, List<String> items) {
    if (items.isEmpty) return pw.Container();
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 5),
          ...items.map(
            (item) => pw.Padding(
              padding: const pw.EdgeInsets.only(left: 10),
              child: pw.Bullet(
                text: item,
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Divider(color: PdfColors.grey300),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(PreferenceCardDetailsModel card) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Divider(),
        pw.Text(
          'Generated by Tbsosick',
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
        ),
      ],
    );
  }
}
