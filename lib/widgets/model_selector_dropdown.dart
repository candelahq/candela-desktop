import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// A reusable dropdown widget for selecting a specific model from a list
/// of available models, used for client-side filtering.
class ModelSelectorDropdown extends StatelessWidget {
  final List<String> models;
  final String? selected;
  final ValueChanged<String?> onChanged;

  const ModelSelectorDropdown({
    super.key,
    required this.models,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: CandelaColors.bgTertiary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CandelaColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: selected,
          hint: const Text('All Models',
              style: TextStyle(fontSize: 12, color: CandelaColors.textMuted)),
          icon: const Icon(Icons.arrow_drop_down,
              size: 16, color: CandelaColors.textMuted),
          style:
              const TextStyle(fontSize: 12, color: CandelaColors.textPrimary),
          dropdownColor: CandelaColors.bgTertiary,
          items: [
            const DropdownMenuItem<String?>(
              value: null,
              child: Text('All Models'),
            ),
            ...models.map((m) => DropdownMenuItem(
                  value: m,
                  child: Text(m),
                )),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
