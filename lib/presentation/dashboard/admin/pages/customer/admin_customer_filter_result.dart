import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';



enum CustomerFilterType { area, salesperson }

class CustomerFilterResult {
  final CustomerFilterType filterType;
  final String area;
  final String salesperson;

  CustomerFilterResult({
    required this.filterType,
    required this.area,
    required this.salesperson,
  });
}



/// MODAL UI
class CustomerFilterModal extends HookConsumerWidget {
  final List<String> areas;
  final List<String> salespersons;
  final String selectedArea;
  final String selectedSalesperson;

  const CustomerFilterModal({
    super.key,
    required this.areas,
    required this.salespersons,
    required this.selectedArea,
    required this.selectedSalesperson,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterType =
        useState<CustomerFilterType>(CustomerFilterType.area);

    final area = useState<String>(selectedArea);
    final salesperson = useState<String>(selectedSalesperson);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Filter Customers",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          /// STEP 1 — CATEGORY TYPE
          DropdownButtonFormField<CustomerFilterType>(
            value: filterType.value,
            decoration: const InputDecoration(
              labelText: "Category",
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(
                value: CustomerFilterType.area,
                child: Text("Area"),
              ),
              DropdownMenuItem(
                value: CustomerFilterType.salesperson,
                child: Text("Salesperson"),
              ),
            ],
            onChanged: (v) => filterType.value = v!,
          ),

          const SizedBox(height: 16),

          /// STEP 2 — AREA VALUES
          if (filterType.value == CustomerFilterType.area)
            DropdownButtonFormField<String>(
              value: area.value,
              decoration: const InputDecoration(
                labelText: "Area",
                border: OutlineInputBorder(),
              ),
              items: areas
                  .map(
                    (a) => DropdownMenuItem(value: a, child: Text(a)),
                  )
                  .toList(),
              onChanged: (v) => area.value = v!,
            ),

          /// STEP 2 — SALESPERSON VALUES
          if (filterType.value == CustomerFilterType.salesperson)
            Autocomplete<String>(
              initialValue: TextEditingValue(
                text: salesperson.value == "All" ? "" : salesperson.value,
              ),
              optionsBuilder: (text) {
                if (text.text.isEmpty) {
                  return salespersons.where((e) => e != "All");
                }
                return salespersons.where(
                  (e) =>
                      e != "All" &&
                      e.toLowerCase().contains(text.text.toLowerCase()),
                );
              },
              onSelected: (s) => salesperson.value = s,
              fieldViewBuilder: (_, controller, focusNode, __) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: "Salesperson",
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),

          const SizedBox(height: 24),

          /// APPLY
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
           onPressed: () {
  Navigator.pop(
    context,
    CustomerFilterResult(
      filterType: filterType.value,
      area: filterType.value == CustomerFilterType.area
          ? area.value
          : "All",
      salesperson: filterType.value == CustomerFilterType.salesperson
          ? salesperson.value
          : "All",
    ),
  );
},

              child: const Text("Apply"),
            ),
          ),
        ],
      ),
    );
  }
}
