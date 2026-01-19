// for  admin and user transaction od print preview screen that it for helper no other use 
import 'package:shopx/domain/config/company_config.dart';
import 'package:shopx/domain/reciept/receipt_data.dart';
import 'package:shopx/domain/sales/sale.dart';

ReceiptData receiptFromSale(Sale sale) {
  final receiptItems = sale.items.map((item) {
    return ReceiptItem(
      nameEn: item.productName,
      nameAr: item.productNameAr,
      unitPrice: item.unitPrice,
      quantity: item.quantity,
    );
  }).toList();

  return ReceiptData(
    companyNameEn: CompanyConfig.companyNameEn,
    companyNameAr: CompanyConfig.companyNameAr,
    city: CompanyConfig.city,
    country: CompanyConfig.country,
    crNumber: CompanyConfig.crNumber,
    vatNumber: CompanyConfig.vatNumber,
    mobile: CompanyConfig.mobile,

    invoiceNumber: sale.id.toString(),
    invoiceDate: sale.saleDate,
    customerName: sale.customerName,

    items: receiptItems,
    subTotal: sale.subtotalAmount,
    discount: sale.discountAmount,
    vatPercentage: sale.vatPercentage,
    vatAmount: sale.vatAmount,
    netTotal: sale.totalAmount,

    qrPayload: 'Invoice:${sale.id}',
  );
}
