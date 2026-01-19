/*
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shopx/domain/reciept/receipt_data.dart';

class CompanyFixedData {
  static const companyNameEn = 'HOFAN AHMED ALI AL GARNI TRADING EST.';
  static const companyNameAr = 'مؤسسة حوفان أحمد علي القرني للتجارة';

  static const businessEn = 'Coffee Machines Rental & Coffee Service Provider';
  static const businessAr = 'لتأجير مكائن القهوة وتقديم خدمات القهوة';

  static const vatNumber = '310161813800003';
  static const crNumber = '1010826267';
}

class PdfReceiptService {
  static Future<File> generateReceiptPdf(ReceiptData receipt) async {
    final pdf = pw.Document();

    // Arabic fonts
    final arabicFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Cairo-Regular.ttf'),
    );
    final arabicFontBold = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Cairo-Bold.ttf'),
    );

    final logoImage = pw.MemoryImage(
      (await rootBundle.load(
        'assets/images/pdf_logo.png',
      )).buffer.asUint8List(),
    );

    final today = receipt.invoiceDate.toString().split(' ').first;

    final qrData = generateZatcaQr(
      sellerName: CompanyFixedData.companyNameEn,
      vatNumber: CompanyFixedData.vatNumber,
      invoiceDate: receipt.invoiceDate,
      totalWithVat: receipt.netTotal,
      vatAmount: receipt.vatAmount,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Center(
                  child: pw.Text(
                    'Tax Invoice\nفاتورة ضريبية',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: arabicFontBold, fontSize: 16),
                  ),
                ),
                pw.SizedBox(height: 16),

                // pw.Row(
                //   crossAxisAlignment: pw.CrossAxisAlignment.start,
                //   children: [
                //     // LEFT: FIXED COMPANY INFO
                //     pw.Expanded(
                //       child: pw.Column(
                //         crossAxisAlignment: pw.CrossAxisAlignment.start,
                //         children: [
                //           // pw.Text(
                //           //   'JOYBREWS COFFEE MACHINES',
                //           //   style: pw.TextStyle(
                //           //     font: arabicFontBold,
                //           //     fontSize: 9,
                //           //   ),
                //           // ),
                //           pw.Text(
                //             CompanyFixedData.companyNameEn,
                //             style: pw.TextStyle(
                //               font: arabicFontBold,
                //               fontSize: 10,
                //             ),
                //           ),
                //           pw.Text(
                //             CompanyFixedData.companyNameAr,
                //             style: pw.TextStyle(font: arabicFont, fontSize: 9),
                //           ),
                //           pw.SizedBox(height: 4),
                //           pw.Text(
                //             CompanyFixedData.businessEn,
                //             style: pw.TextStyle(font: arabicFont, fontSize: 9),
                //           ),
                //           pw.Text(
                //             CompanyFixedData.businessAr,
                //             style: pw.TextStyle(font: arabicFont, fontSize: 9),
                //           ),
                //           pw.SizedBox(height: 6),
                //           pw.Text(
                //             'VAT No: ${CompanyFixedData.vatNumber}',
                //             style: pw.TextStyle(font: arabicFont, fontSize: 9),
                //           ),
                //           pw.Text(
                //             'CR No: ${CompanyFixedData.crNumber}',
                //             style: pw.TextStyle(font: arabicFont, fontSize: 9),
                //           ),
                //         ],
                //       ),
                //     ),

                //     pw.SizedBox(width: 12),

                //     // RIGHT: INVOICE INFO
                //     pw.Expanded(
                //       child: pw.Table(
                //         border: pw.TableBorder.all(),
                //         children: [
                //           _infoRow(
                //             arabicFont,
                //             'Inv No',
                //             receipt.invoiceNumber,
                //             'رقم الفاتورة',
                //             receipt.invoiceNumber,
                //           ),
                //           _infoRow(
                //             arabicFont,
                //             'Inv Date',
                //             today,
                //             'تاريخ الإصدار',
                //             today,
                //           ),
                //           _infoRow(
                //             arabicFont,
                //             'Delivery',
                //             today,
                //             'تاريخ التوريد',
                //             today,
                //           ),
                //           _infoRow(
                //             arabicFont,
                //             'Due Date',
                //             today,
                //             'تاريخ الاستحقاق',
                //             today,
                //           ),
                //           _infoRow(
                //             arabicFont,
                //             'Ref',
                //             receipt.invoiceNumber,
                //             'المرجع',
                //             receipt.invoiceNumber,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(3),
                    1: const pw.FixedColumnWidth(90),
                    2: const pw.FlexColumnWidth(3),
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        // LEFT — ENGLISH
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                CompanyFixedData.companyNameEn,
                                style: pw.TextStyle(
                                  font: arabicFontBold,
                                  fontSize: 10,
                                ),
                              ),
                              pw.Text(
                                CompanyFixedData.businessEn,
                                style: pw.TextStyle(
                                  font: arabicFont,
                                  fontSize: 9,
                                ),
                              ),
                              pw.SizedBox(height: 6),
                              pw.Text(
                                'VAT No: ${CompanyFixedData.vatNumber}',
                                style: pw.TextStyle(
                                  font: arabicFont,
                                  fontSize: 9,
                                ),
                              ),
                              pw.Text(
                                'CR No: ${CompanyFixedData.crNumber}',
                                style: pw.TextStyle(
                                  font: arabicFont,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // CENTER — LOGO
                        pw.Center(
                          child: pw.Image(
                            logoImage,
                            width: 70,
                            height: 70,
                            fit: pw.BoxFit.contain,
                          ),
                        ),

                        // RIGHT — ARABIC
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(6),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.end,
                            children: [
                              pw.Text(
                                CompanyFixedData.companyNameAr,
                                style: pw.TextStyle(
                                  font: arabicFontBold,
                                  fontSize: 10,
                                ),
                                textDirection: pw.TextDirection.rtl,
                              ),
                              pw.Text(
                                CompanyFixedData.businessAr,
                                style: pw.TextStyle(
                                  font: arabicFont,
                                  fontSize: 9,
                                ),
                                textDirection: pw.TextDirection.rtl,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                pw.SizedBox(height: 16),

                // ================= INVOICE INFO TABLE (MODEL MATCH) =================
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FixedColumnWidth(80),
                    1: const pw.FlexColumnWidth(2),
                    2: const pw.FixedColumnWidth(80),
                    3: const pw.FlexColumnWidth(2),
                  },
                  children: [
                    _infoRow(
                      arabicFont,
                      'Vendor',
                      CompanyFixedData.companyNameEn,
                      'اسم المورد',
                      CompanyFixedData.companyNameAr,
                    ),
                    _infoRow(
                      arabicFont,
                      'Inv No',
                      receipt.invoiceNumber,
                      'رقم الفاتورة',
                      receipt.invoiceNumber,
                    ),
                    _infoRow(
                      arabicFont,
                      'Inv Date',
                      today,
                      'تاريخ الإصدار',
                      today,
                    ),
                    _infoRow(
                      arabicFont,
                      'Delivery Date',
                      today,
                      'تاريخ التوريد',
                      today,
                    ),
                    _infoRow(
                      arabicFont,
                      'Due Date',
                      today,
                      'تاريخ الاستحقاق',
                      today,
                    ),
                    _infoRow(
                      arabicFont,
                      'Ref',
                      receipt.invoiceNumber,
                      'المرجع',
                      receipt.invoiceNumber,
                    ),
                    _infoRow(
                      arabicFont,
                      'VAT No',
                      CompanyFixedData.vatNumber,
                      'الرقم الضريبي',
                      CompanyFixedData.vatNumber,
                    ),
                  ],
                ),

                pw.SizedBox(height: 16),

                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    _infoRow(
                      arabicFont,
                      'Customer',
                      receipt.customerName,
                      'اسم العميل',
                      receipt.customerName,
                    ),

                    if (receipt.customerAddress != null &&
                        receipt.customerAddress!.isNotEmpty)
                      _infoRow(
                        arabicFont,
                        'Address',
                        receipt.customerAddress!,
                        'العنوان',
                        receipt.customerAddress!,
                      ),

                    if (receipt.customerPhone != null &&
                        receipt.customerPhone!.isNotEmpty)
                      _infoRow(
                        arabicFont,
                        'Phone',
                        receipt.customerPhone!,
                        'الهاتف',
                        receipt.customerPhone!,
                      ),

                    if (receipt.customerVat != null &&
                        receipt.customerVat!.isNotEmpty)
                      _infoRow(
                        arabicFont,
                        'VAT No',
                        receipt.customerVat!,
                        'الرقم الضريبي',
                        receipt.customerVat!,
                      ),
                  ],
                ),

                pw.SizedBox(height: 16),

                // =========================================================
                // ITEMS TABLE
                // =========================================================
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FixedColumnWidth(30), // S.No
                    1: const pw.FlexColumnWidth(3), // Description
                    2: const pw.FixedColumnWidth(50), // Qty
                    3: const pw.FixedColumnWidth(60), // Price
                    4: const pw.FixedColumnWidth(50), // VAT
                    5: const pw.FixedColumnWidth(70), // Amount
                  },
                  children: [
                    // Header
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.grey300,
                      ),
                      children: [
                        _cell(arabicFontBold, 'م\nS'),
                        _cell(arabicFontBold, 'البيان\nDescription'),
                        _cell(arabicFontBold, 'العدد\nQty'),
                        _cell(arabicFontBold, 'السعر\nPrice'),
                        _cell(arabicFontBold, 'الضريبة\nVAT'),
                        _cell(arabicFontBold, 'الإجمالي\nAmount'),
                      ],
                    ),

                    // Items
                    ...List.generate(receipt.items.length, (index) {
                      final item = receipt.items[index];
                      final total = item.unitPrice * item.quantity;
                      // final vat = total * receipt.vatPercentage / 100;

                      // return pw.TableRow(
                      //   children: [
                      //     _cell(arabicFont, '${index + 1}'),
                      //     _cell(arabicFont, item.nameEn),
                      //     _cell(arabicFont, item.quantity.toString()),
                      //     _cell(arabicFont, item.unitPrice.toStringAsFixed(2)),
                      //     // _cell(arabicFont, '${vat.toStringAsFixed(2)} SR'),
                      //     _cell(arabicFont, '${total.toStringAsFixed(2)} SR'),
                      //   ],
                      // );

                      final vat = total * receipt.vatPercentage / 100;

                      return pw.TableRow(
                        children: [
                          _cell(arabicFont, '${index + 1}'),
                          _cell(
                            arabicFont,
                            item.nameAr != null && item.nameAr!.isNotEmpty
                                ? '${item.nameEn}\n${item.nameAr}'
                                : item.nameEn,
                          ),
                          _cell(arabicFont, item.quantity.toString()),
                          _cell(arabicFont, item.unitPrice.toStringAsFixed(2)),
                          _cell(arabicFont, vat.toStringAsFixed(2)),
                          _cell(arabicFont, total.toStringAsFixed(2)),
                        ],
                      );
                    }),
                  ],
                ),

                pw.SizedBox(height: 16),

                // =========================================================
                // TOTALS + QR
                // =========================================================

                // pw.Row(
                //   crossAxisAlignment: pw.CrossAxisAlignment.start,
                //   children: [
                //     // QR
                //     pw.Expanded(
                //       child: pw.BarcodeWidget(
                //         barcode: pw.Barcode.qrCode(),
                //         data: qrData,
                //         width: 110,
                //         height: 110,
                //       ),
                //     ),

                //     // Totals
                //     pw.Expanded(
                //       child: pw.Table(
                //         border: pw.TableBorder.all(),
                //         children: [
                //           //                         _totalRow(
                //           //   arabicFont,
                //           //   'Taxable Amount\nالمبلغ الخاضع للضريبة',
                //           //    receipt.subTotal,
                //           //   // receipt.subTotal - (receipt.discount ?? 0.0),
                //           // ),

                //           //                           _totalRow(
                //           //                             arabicFont,
                //           //                             'Discount\nالخصم',
                //           //                             receipt.discount ?? 0.0,
                //           //                           ),
                //           //                           // _totalRow(
                //           //                           //   arabicFont,
                //           //                           //   'Amount After Discount\nالمبلغ بعد الخصم',
                //           //                           //   receipt.subTotal - (receipt.discount ?? 0.0),
                //           //                           // ),
                //           //                           _totalRow(
                //           //                             arabicFont,
                //           //                             'VAT ${receipt.vatPercentage}%\nضريبة القيمة المضافة',
                //           //                             receipt.vatAmount,
                //           //                           ),
                //           //                           _totalRow(
                //           //                             arabicFontBold,
                //           //                             'Total Amount with VAT\nإجمالي المبلغ مع الضريبة',
                //           //                             receipt.netTotal,
                //           //                           ),
                //           _totalRow(
                //             arabicFont,
                //             'Taxable Amount\nالمبلغ الخاضع للضريبة',
                //             receipt.subTotal,
                //           ),
                //           _totalRow(
                //             arabicFont,
                //             'Discount\nالخصم',
                //             receipt.discount ?? 0.0,
                //           ),
                //           _totalRow(
                //             arabicFont,
                //             'Amount After Discount\nالمبلغ بعد الخصم',
                //             receipt.subTotal - (receipt.discount ?? 0.0),
                //           ),
                //           _totalRow(
                //             arabicFont,
                //             'VAT ${receipt.vatPercentage}%\nضريبة القيمة المضافة',
                //             receipt.vatAmount,
                //           ),
                //           _totalRow(
                //             arabicFontBold,
                //             'Total Amount with VAT\nإجمالي المبلغ مع الضريبة',
                //             receipt.netTotal,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FixedColumnWidth(140),
                    1: const pw.FlexColumnWidth(),
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        // QR CELL
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.BarcodeWidget(
                            barcode: pw.Barcode.qrCode(),
                            data: qrData,
                            width: 120,
                            height: 120,
                          ),
                        ),

                        // TOTALS CELL
                        pw.Table(
                          border: pw.TableBorder.all(),
                          children: [
                            _totalRow(
                              arabicFont,
                              'Taxable Amount\nالمبلغ الخاضع للضريبة',
                              receipt.subTotal,
                            ),
                            _totalRow(
                              arabicFont,
                              'Discount\nالخصم',
                              receipt.discount ?? 0.0,
                            ),
                            _totalRow(
                              arabicFont,
                              'Amount After Discount\nالمبلغ بعد الخصم',
                              receipt.subTotal - (receipt.discount ?? 0.0),
                            ),
                            _totalRow(
                              arabicFont,
                              'VAT ${receipt.vatPercentage}%\nضريبة القيمة المضافة',
                              receipt.vatAmount,
                            ),
                            _totalRow(
                              arabicFontBold,
                              'Total Amount with VAT\nإجمالي المبلغ مع الضريبة',
                              receipt.netTotal,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                pw.SizedBox(height: 24),

                // =========================================================
                // SIGNATURES
                // =========================================================
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        _cell(arabicFont, 'Salesman\nالبائع'),
                        _cell(arabicFont, 'Approved by\nاعتمد بواسطة'),
                        _cell(arabicFont, 'Received by\nاستلم بواسطة'),
                        _cell(arabicFont, 'Customer Signature\nتوقيع العميل'),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        _cell(arabicFont, ''),
                        _cell(arabicFont, ''),
                        _cell(arabicFont, ''),
                        _cell(arabicFont, ''),
                      ],
                    ),
                  ],
                ),

                pw.SizedBox(height: 16),

                pw.Text(
                  'شكراً لتعاملكم معنا',
                  style: pw.TextStyle(font: arabicFont, fontSize: 11),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/invoice_${receipt.invoiceNumber}.pdf');

    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // =========================================================
  // HELPERS
  // =========================================================

  static pw.TableRow _infoRow(
    pw.Font font,
    String enLabel,
    String enValue,
    String arLabel,
    String arValue,
  ) {
    return pw.TableRow(
      children: [
        _cell(font, enLabel),
        _cell(font, enValue),
        _cell(font, arLabel),
        _cell(font, arValue),
      ],
    );
  }

  static pw.Widget _cell(pw.Font font, String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: 9)),
    );
  }

  static pw.TableRow _totalRow(pw.Font font, String label, double value) {
    return pw.TableRow(
      children: [_cell(font, label), _cell(font, value.toStringAsFixed(2))],
    );
  }

  static String generateZatcaQr({
    required String sellerName,
    required String vatNumber,
    required DateTime invoiceDate,
    required double totalWithVat,
    required double vatAmount,
  }) {
    List<int> bytes = [];

    void addTLV(int tag, String value) {
      final valueBytes = value.codeUnits;
      bytes.add(tag);
      bytes.add(valueBytes.length);
      bytes.addAll(valueBytes);
    }

    addTLV(1, sellerName);
    addTLV(2, vatNumber);
    addTLV(3, invoiceDate.toIso8601String());
    addTLV(4, totalWithVat.toStringAsFixed(2));
    addTLV(5, vatAmount.toStringAsFixed(2));

    return base64Encode(bytes);
  }
}

*/
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shopx/domain/reciept/receipt_data.dart';

class CompanyFixedData {
  static const companyNameEn = 'HOFAN AHMED AL AL GARNI TRADING EST.';
  static const companyNameAr = 'مؤسسة حوفان أحمد علي القرني للتجارة';

  static const businessEn =
      'JOYBREWS COFFEE MACHINES\nCoffee Machines Rental & Coffee Service Provider';
  static const businessAr =
      'جوي برووس ماكينات القهوة\nلتأجير مكائن القهوة وتقديم خدمات القهوة';

  static const vatNumber = '310161813800003';
  static const crNumber = '1010826267';
}

class PdfReceiptService {
  static Future<File> generateReceiptPdf(ReceiptData receipt) async {
    final pdf = pw.Document();

    final regular =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Cairo-Regular.ttf'));
    final bold =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Cairo-Bold.ttf'));

    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/pdf_logo.png'))
          .buffer
          .asUint8List(),
    );

    final date = receipt.invoiceDate.toString().split(' ').first;

    final qrData = _zatcaQr(
      sellerName: CompanyFixedData.companyNameEn,
      vatNumber: CompanyFixedData.vatNumber,
      invoiceDate: receipt.invoiceDate,
      totalWithVat: receipt.netTotal,
      vatAmount: receipt.vatAmount,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(16),
        build: (_) => pw.Directionality(
          textDirection: pw.TextDirection.rtl,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [

              // ================= HEADER (NO BOX) =================
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: _headerBlock(
                      bold,
                      CompanyFixedData.companyNameEn,
                      CompanyFixedData.businessEn,
                      'VAT No: ${CompanyFixedData.vatNumber}\nCR No: ${CompanyFixedData.crNumber}',
                      pw.TextAlign.left,
                    ),
                  ),
                  pw.Center(child: pw.Image(logo, width: 75)),
                  pw.Expanded(
                    child: _headerBlock(
                      bold,
                      CompanyFixedData.companyNameAr,
                      CompanyFixedData.businessAr,
                      'الرقم الضريبي: ${CompanyFixedData.vatNumber}\nالسجل التجاري: ${CompanyFixedData.crNumber}',
                      pw.TextAlign.right,
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 10),

              // ================= BOX 1 & 2 : VENDOR + CUSTOMER =================
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(),
                  1: const pw.FlexColumnWidth(),
                },
                children: [
                  pw.TableRow(children: [
                    _boxedInfo(
                      regular,
                      'Vendor Details',
                      [
                        'Name: ${CompanyFixedData.companyNameEn}',
                        'VAT: ${CompanyFixedData.vatNumber}',
                        'CR: ${CompanyFixedData.crNumber}',
                        'Invoice No: ${receipt.invoiceNumber}',
                        'Date: $date',
                      ],
                    ),
                    _boxedInfo(
                      regular,
                      'Customer Details',
                      [
                        'Name: ${receipt.customerName}',
                        'Address: ${receipt.customerAddress ?? ''}',
                      ],
                    ),
                  ]),
                ],
              ),

              pw.SizedBox(height: 10),

              // ================= BOX 3 : ITEMS =================
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FixedColumnWidth(30),
                  1: const pw.FlexColumnWidth(4),
                  2: const pw.FixedColumnWidth(45),
                  3: const pw.FixedColumnWidth(70),
                  4: const pw.FixedColumnWidth(45),
                  5: const pw.FixedColumnWidth(70),
                },
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      _cell(bold, 'S'),
                      _cell(bold, 'Description\nالبيان'),
                      _cell(bold, 'Qty\nالعدد'),
                      _cell(bold, 'Price'),
                      _cell(bold, 'VAT'),
                      _cell(bold, 'Amount'),
                    ],
                  ),
                  ...receipt.items.asMap().entries.map((e) {
                    final i = e.key + 1;
                    final item = e.value;
                    final total = item.unitPrice * item.quantity;
                    final vat = total * receipt.vatPercentage / 100;

                    return pw.TableRow(children: [
                      _cell(regular, '$i'),
                      _cell(
                        regular,
                        item.nameAr?.isNotEmpty == true
                            ? '${item.nameEn}\n${item.nameAr}'
                            : item.nameEn,
                      ),
                      _cell(regular, '${item.quantity}'),
                      _cell(regular, item.unitPrice.toStringAsFixed(2)),
                      _cell(regular, vat.toStringAsFixed(2)),
                      _cell(regular, total.toStringAsFixed(2)),
                    ]);
                  }),
                ],
              ),

              pw.SizedBox(height: 10),

              // ================= BOX 4 : QR + TOTAL =================
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FixedColumnWidth(140),
                  1: const pw.FlexColumnWidth(),
                },
                children: [
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.BarcodeWidget(
                        barcode: pw.Barcode.qrCode(),
                        data: qrData,
                        width: 120,
                        height: 120,
                      ),
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(),
                      children: [
                        _totalRow(regular,
                            'Taxable Amount\nالمبلغ الخاضع للضريبة',
                            receipt.subTotal),
                        _totalRow(regular, 'Discount\nالخصم',
                            receipt.discount ?? 0),
                        _totalRow(regular,
                            'Amount After Discount\nالصافي بعد الخصم',
                            receipt.subTotal - (receipt.discount ?? 0)),
                        _totalRow(regular,
                            'VAT ${receipt.vatPercentage}%',
                            receipt.vatAmount),
                        _totalRow(bold,
                            'Total Amount with VAT\nإجمالي المبلغ مع الضريبة',
                            receipt.netTotal),
                      ],
                    ),
                  ]),
                ],
              ),

              pw.SizedBox(height: 10),

              // ================= BOX 5 : SIGNATURE =================
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FlexColumnWidth(),
                  1: const pw.FlexColumnWidth(),
                  2: const pw.FlexColumnWidth(),
                  3: const pw.FlexColumnWidth(),
                },
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.grey300),
                    children: [
                      _cell(bold, 'Salesman\nالبائع'),
                      _cell(bold, 'Approved by\nاعتمد بواسطة'),
                      _cell(bold, 'Received by\nاستلم بواسطة'),
                      _cell(bold, 'Customer Signature\nتوقيع العميل'),
                    ],
                  ),
                  pw.TableRow(children: [
                    _cell(regular, ''),
                    _cell(regular, ''),
                    _cell(regular, ''),
                    _cell(regular, ''),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/invoice_${receipt.invoiceNumber}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // ================= HELPERS =================

  static pw.Widget _headerBlock(
    pw.Font font,
    String title,
    String body,
    String footer,
    pw.TextAlign align,
  ) {
    return pw.Column(
      crossAxisAlignment: align == pw.TextAlign.left
          ? pw.CrossAxisAlignment.start
          : pw.CrossAxisAlignment.end,
      children: [
        pw.Text(title, style: pw.TextStyle(font: font, fontSize: 9)),
        pw.Text(body, style: pw.TextStyle(font: font, fontSize: 8)),
        pw.SizedBox(height: 3),
        pw.Text(footer, style: pw.TextStyle(font: font, fontSize: 8)),
      ],
    );
  }

  static pw.Widget _boxedInfo(
    pw.Font font,
    String title,
    List<String> lines,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(font: font, fontSize: 9)),
          pw.SizedBox(height: 4),
          ...lines.map(
            (e) => pw.Text(e, style: pw.TextStyle(font: font, fontSize: 8)),
          ),
        ],
      ),
    );
  }

  static pw.Widget _cell(pw.Font font, String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: 8)),
    );
  }

  static pw.TableRow _totalRow(pw.Font font, String label, double value) {
    return pw.TableRow(children: [
      _cell(font, label),
      _cell(font, value.toStringAsFixed(2)),
    ]);
  }

  static String _zatcaQr({
    required String sellerName,
    required String vatNumber,
    required DateTime invoiceDate,
    required double totalWithVat,
    required double vatAmount,
  }) {
    final bytes = <int>[];

    void add(int tag, String value) {
      final v = value.codeUnits;
      bytes..add(tag)..add(v.length)..addAll(v);
    }

    add(1, sellerName);
    add(2, vatNumber);
    add(3, invoiceDate.toIso8601String());
    add(4, totalWithVat.toStringAsFixed(2));
    add(5, vatAmount.toStringAsFixed(2));

    return base64Encode(bytes);
  }
}
