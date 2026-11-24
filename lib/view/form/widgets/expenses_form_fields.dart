import 'package:fintracker/model/category.dart';
import 'package:fintracker/model/payment_method.dart';
import 'package:fintracker/view/form/widgets/form_field_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpensesFormFields extends StatelessWidget {
  const ExpensesFormFields({
    super.key,
    required this.valueController,
    required this.descriptionController,
    required this.dateController,
    required this.categories,
    required this.selectedCategory,
    required this.categoryValidator,
    required this.onCategorySelected,
    required this.paymentMethod,
    required this.paymentMethodValidator,
    required this.onPaymentMethodSelected,
    required this.onSelectDate,
    required this.valueValidator,
    required this.descriptionValidator,
  });

  final TextEditingController valueController;
  final TextEditingController descriptionController;
  final TextEditingController dateController;
  final List<Category> categories;
  final int selectedCategory;
  final FormFieldValidator<int> categoryValidator;
  final ValueChanged<int> onCategorySelected;
  final PaymentMethod? paymentMethod;
  final FormFieldValidator<PaymentMethod> paymentMethodValidator;
  final ValueChanged<PaymentMethod> onPaymentMethodSelected;
  final VoidCallback onSelectDate;
  final FormFieldValidator<String> valueValidator;
  final FormFieldValidator<String> descriptionValidator;

  @override
  Widget build(BuildContext context) {
    const color = Colors.red;

    return Column(
      children: [
        FormFieldCard(
          title: 'Value',
          icon: Icons.arrow_downward,
          iconColor: color,
          field: TextFormField(
            controller: valueController,
            maxLength: 10,
            decoration: const InputDecoration(
              prefix: Text("- R\$ ", style: TextStyle(color: color)),
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
        ),
        FormFieldCard(
          title: 'Category',
          icon: Icons.category,
          iconColor: color,
          field: FormField<int>(
            initialValue: selectedCategory,
            validator: categoryValidator,
            builder: (state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    for (var i = 0; i < categories.length; i++)
                      ChoiceChip(
                        label: Text(categories[i].name),
                        selected: selectedCategory == i,
                        onSelected: (_) {
                          onCategorySelected(i);
                          state.didChange(i);
                        },
                        selectedColor: color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                  ],
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        FormFieldCard(
          title: 'Payment Method',
          icon: Icons.credit_card,
          iconColor: color,
          field: FormField<PaymentMethod>(
            initialValue: paymentMethod,
            validator: paymentMethodValidator,
            builder: (state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    for (final method in PaymentMethod.values)
                      ChoiceChip(
                        label: Text(method.name),
                        selected: paymentMethod == method,
                        onSelected: (_) {
                          onPaymentMethodSelected(method);
                          state.didChange(method);
                        },
                        selectedColor: color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                  ],
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12),
                    child: Text(
                      state.errorText!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
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
