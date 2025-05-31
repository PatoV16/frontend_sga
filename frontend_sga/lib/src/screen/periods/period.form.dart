import 'package:flutter/material.dart';
import 'package:frontend_sga/src/models/period.model.dart';
import 'package:frontend_sga/src/service/period.service.dart';
class PeriodFormPage extends StatefulWidget {
  final Period? period; // Si viene, es para editar

  const PeriodFormPage({Key? key, this.period}) : super(key: key);

  @override
  _PeriodFormPageState createState() => _PeriodFormPageState();
}

class _PeriodFormPageState extends State<PeriodFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _periodController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  final PeriodService _periodService = PeriodService();

  @override
  void initState() {
    super.initState();
    if (widget.period != null) {
      _periodController.text = widget.period!.period;
      _nameController.text = widget.period!.name;
      _descriptionController.text = widget.period!.description ?? '';
      _startDate = widget.period!.startDate;
      _endDate = widget.period!.endDate;
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final initialDate = isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now());
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = newDate;
        } else {
          _endDate = newDate;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null || _endDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecciona fechas válidas')),
        );
        return;
      }
      if (_endDate!.isBefore(_startDate!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La fecha final debe ser posterior a la inicial')),
        );
        return;
      }

      final newPeriod = Period(
        id: widget.period?.id,
        period: _periodController.text,
        startDate: _startDate!,
        endDate: _endDate!,
        name: _nameController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      );

      try {
        if (widget.period == null) {
          await _periodService.createPeriod(newPeriod);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Period creado exitosamente')),
          );
        } else {
          await _periodService.updatePeriod(widget.period!.id!, newPeriod);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Period actualizado exitosamente')),
          );
        }
        Navigator.of(context).pop(true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _periodController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.period == null ? 'Crear Period' : 'Editar Period'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _periodController,
                decoration: const InputDecoration(labelText: 'Period'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingresa el periodo';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(_startDate == null ? 'Seleccionar fecha de inicio' : 'Inicio: ${_startDate!.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              ListTile(
                title: Text(_endDate == null ? 'Seleccionar fecha final' : 'Fin: ${_endDate!.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingresa el nombre';
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción (opcional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.period == null ? 'Crear' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
