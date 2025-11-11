import 'package:flutter/material.dart';
import 'package:money_app/data/model/transaction.dart';
import 'package:money_app/data/repository/money_repository.dart';

class EditPage extends StatefulWidget {
  final Transaction ts;
  const EditPage({super.key, required this.ts});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List<String> categories = [
    'Gaji',
    'Makanan',
    'Transportasi',
    'Hiburan',
    'Tagihan',
    'Belanja',
    'Lainnya',
  ];

  final _formKey = GlobalKey<FormState>();
  final _categoryCtr = TextEditingController();
  final _descCtr = TextEditingController();
  final _amountCtr = TextEditingController();

  String _type = 'income';
  DateTime _selectedDate = DateTime.now();
  final _repo = MoneyRepository();

  @override
  void initState() {
    super.initState();
    _type = widget.ts.type;
    _categoryCtr.text = widget.ts.category;
    _amountCtr.text = widget.ts.amount.toString();
    _descCtr.text = widget.ts.description;
    _selectedDate = DateTime.parse(widget.ts.date);
  }

  @override
  void dispose() {
    _categoryCtr.dispose();
    _descCtr.dispose();
    _amountCtr.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amountCtr.text) ?? 0.0;

    final tx = Transaction(
      type: _type,
      category: _categoryCtr.text.trim(),
      description: _descCtr.text.trim(),
      amount: amount,
      date: _selectedDate.toIso8601String(),
    );

    await _repo.updateTransaction(widget.ts.id!, tx);
    if (mounted) Navigator.of(context).pop(true);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Transaki')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'income', child: Text('Income')),
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                ],
                onChanged: (v) => setState(() => _type = v ?? 'income'),
                decoration: const InputDecoration(labelText: 'tipe'),
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _categoryCtr.text,
                decoration: const InputDecoration(labelText: 'Kategori'),
                items: categories
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (v) => _categoryCtr.text = v ?? '',
                validator: (v) =>
                    (v == null || v.trim().isEmpty ? 'Pilih kategori' : null),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _descCtr,
                decoration: const InputDecoration(labelText: "Deskripsi"),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Maasukkan despripsi'
                    : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: _amountCtr,
                decoration: const InputDecoration(labelText: 'Nominal'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Masukkan nominal';
                  final n = double.tryParse(v);
                  if (n == null || v.trim().isEmpty)
                    return 'Masukkan angka yang valid';
                  if (n <= 0) return 'Nominal harus lebih besar dari 0';
                  return null;
                },
              ),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Tanggal: ${_selectedDate.toLocal().toString().split('T').first}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Pilih tanggal'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton(onPressed: _save, child: const Text('Simpan')),
            ],
          ),
        ),
      ),
    );
  }
}
