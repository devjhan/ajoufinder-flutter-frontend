import 'package:ajoufinder/domain/repository/board_repository.dart';
import 'package:ajoufinder/injection_container.dart';
import 'package:flutter/material.dart';

class FilterMenuOverlay extends StatefulWidget{
  final Function(int?, String, String) onApply;
  final VoidCallback onCancel;

  const FilterMenuOverlay({
    Key? key,
    required this.onApply,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<FilterMenuOverlay> createState() => _FilterMenuOverlayState();
}

class _FilterMenuOverlayState extends State<FilterMenuOverlay> {
  int? _selectedLocationId;
  String? _selectedItemType = '';
  String? _selectedItemStatus = '';
  final boardRepository = getIt<BoardRepository>();

  final List<int> _locationIds = [];
  final List<String> _types = [];
  final List<String> _statuses = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: theme.canvasColor,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [/*
            _buildDropdown(
              value: _selectedLocationId ?? '전체',
              items: _locationIds,
              label: '위치',
              onChanged: (value) => setState(() => _selectedLocationId = value),
              context: context
            ),*/
            const SizedBox(height: 20),
            _buildDropdown(
              value: _selectedItemType ?? '전체',
              items: _types,
              label: '종류',
              onChanged: (value) => setState(() => _selectedItemType = value),
              context: context
            ),
            const SizedBox(height: 20),
            _buildDropdown(
              value: _selectedItemStatus ?? '전체',
              items: _statuses,
              label: '상태',
              onChanged: (value) => setState(() => _selectedItemStatus = value),
              context: context
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onCancel();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.cardColor,
                    foregroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),  
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('취소'))
                ),
                const SizedBox(width: 16,),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.onApply(_selectedLocationId, _selectedItemType!, _selectedItemStatus!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.cardColor,
                      foregroundColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),  
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('적용'))
                  ),])
                ],
              ),
        ),)
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required String label,
    required Function(String?) onChanged,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}