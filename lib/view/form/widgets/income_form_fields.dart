import 'package:fintracker/view/form/widgets/form_field_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IncomeFormFields extends StatelessWidget {
  const IncomeFormFields({
    super.key,
    required this.valueController,
    required this.descriptionController,
    required this.sourceController,
    required this.dateController,
    required this.onSelectDate,
    required this.valueValidator,
    required this.descriptionValidator,
    required this.sourceValidator,
  });

  final TextEditingController valueController;
  final TextEditingController descriptionController;
  final TextEditingController sourceController;
  final TextEditingController dateController;
  final VoidCallback onSelectDate;
  final FormFieldValidator<String> valueValidator;
  final FormFieldValidator<String> descriptionValidator;
  final FormFieldValidator<String> sourceValidator;

  @override
  Widget build(BuildContext context) {
    const color = Colors.green;

    return Column(
      children: [
        FormFieldCard(
          title: 'Value',
          icon: Icons.arrow_upward,
          iconColor: color,
          field: TextFormField(
            controller: valueController,
            maxLength: 10,
            decoration: const InputDecoration(
              prefix: Text("+ R\$ ", style: TextStyle(color: color)),
              filled: true,
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
            ],
            validator: valueValidator,
          ),
        ),
        FormFieldCard(
          title: 'Description',
          icon: Icons.description,
          iconColor: color,
          field: TextFormField(
            controller: descriptionController,
            maxLength: 20,
            decoration: const InputDecoration(
              filled: true,
              border: InputBorder.none,
            ),
            validator: descriptionValidator,
          ),
          extra: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.account_balance, color: color),
                title: const Text('Source'),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  controller: sourceController,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    filled: true,
                    border: InputBorder.none,
                  ),
                  validator: sourceValidator,
                ),
              ),
            ],
          ),
        ),
        FormFieldCard(
          title: 'Date',
          icon: Icons.calendar_month,
          iconColor: color,
          field: TextFormField(
            controller: dateController,
            readOnly: true,
            onTap: onSelectDate,
            decoration: const InputDecoration(
              filled: true,
              border: InputBorder.none,
              suffixIcon: Icon(Icons.date_range),
            ),
          ),
        ),
      ],
    );
  }
}
