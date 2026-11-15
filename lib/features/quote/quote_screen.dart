import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_header.dart';
import '../../core/widgets/app_icon.dart';
import '../../models/product.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({
    required this.product,
    required this.onHome,
    required this.onBack,
    super.key,
  });

  final Product product;
  final VoidCallback onHome;
  final VoidCallback onBack;

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantity = TextEditingController(text: '1');
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    _quantity.dispose();
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomScrollView(
        key: const PageStorageKey('quote'),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                AppHeader(onHome: widget.onHome),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: widget.onBack,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.foreground,
                      padding: const EdgeInsets.fromLTRB(0, 2, 8, 14),
                    ),
                    icon: const AppIcon('back', size: 19),
                    label: const Text('Retour au produit'),
                  ),
                ),
                const Text(
                  'DEMANDE DE DEVIS',
                  style: TextStyle(
                    fontFamily: 'Barlow Condensed',
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    color: AppColors.foreground,
                  ),
                ),
                const SizedBox(height: 14),
                _productSummary(),
                const SizedBox(height: 18),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _field(
                        controller: _quantity,
                        label: 'Quantité souhaitée',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          final quantity = int.tryParse(value ?? '');
                          if (quantity == null || quantity < 1) {
                            return 'Indiquez une quantité supérieure à zéro.';
                          }
                          return null;
                        },
                      ),
                      _field(
                        controller: _name,
                        label: 'Nom et prénom',
                        textCapitalization: TextCapitalization.words,
                        validator: _requiredValidator,
                      ),
                      _field(
                        controller: _email,
                        label: 'Adresse e-mail',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          final email = value?.trim() ?? '';
                          if (email.isEmpty) return 'Ce champ est obligatoire.';
                          if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                              .hasMatch(email)) {
                            return 'Saisissez une adresse e-mail valide.';
                          }
                          return null;
                        },
                      ),
                      _field(
                        controller: _phone,
                        label: 'Téléphone',
                        keyboardType: TextInputType.phone,
                        validator: _requiredValidator,
                      ),
                      _field(
                        controller: _message,
                        label: 'Message (facultatif)',
                        maxLines: 4,
                        validator: null,
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _prepareRequest,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.yellow,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            side: const BorderSide(
                              color: AppColors.foreground,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Préparer ma demande',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Cette demande reste sur votre appareil et ne sera pas envoyée : aucun service de devis n’est connecté.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.muted,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      );

  Widget _productSummary() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x08000000), blurRadius: 4),
          ],
        ),
        child: Row(
          children: [
            AppIcon(widget.product.iconKey, size: 34, color: AppColors.muted),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Réf. ${widget.product.reference}',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${Product.formatPrice(widget.product.price)} TTC',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            alignLabelWithHint: maxLines > 1,
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.yellowHover),
            ),
          ),
        ),
      );

  String? _requiredValidator(String? value) =>
      value == null || value.trim().isEmpty ? 'Ce champ est obligatoire.' : null;

  void _prepareRequest() {
    if (!_formKey.currentState!.validate()) return;
    final message = _message.text.trim();
    final optionalMessage = message.isEmpty ? '' : 'Message : $message\n';
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Demande préparée'),
        content: Text(
          'Produit : ${widget.product.name}\n'
          'Quantité : ${_quantity.text}\n'
          'Contact : ${_name.text.trim()} (${_email.text.trim()})\n\n'
          'Téléphone : ${_phone.text.trim()}\n'
          '$optionalMessage\n'
          'Cette demande n’a pas été envoyée. Aucun backend n’est connecté.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Compris'),
          ),
        ],
      ),
    );
  }
}
