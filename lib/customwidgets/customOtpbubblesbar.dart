
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpBubblesInput extends StatefulWidget {
  const OtpBubblesInput({
    super.key,
    this.length = 4,
    this.autoFocus = true,
    this.diameter = 62,
    this.strokeWidth = 2.5,
    this.spacing = 16,
    this.borderColor = const Color(0xFF505AF9),
    this.textColor = const Color(0xFF3A2E6E),

    // 🔧 New customization
    this.initialValue = '',
    this.obscure = false,
    this.obscureChar = '•',
    this.tapToFocus = true,
    this.showFocusRing = true,
    this.focusRingColor,
    this.enablePaste = true,     // long-press to paste
    this.enableHaptics = true,   // light haptic on key
    this.readOnly = false,

    // callbacks
    this.onChanged,
    this.onCompleted,
  });

  final int length;
  final bool autoFocus;
  final double diameter;
  final double strokeWidth;
  final double spacing;
  final Color borderColor;
  final Color textColor;

  // 🔧 Custom options
  final String initialValue;
  final bool obscure;
  final String obscureChar;
  final bool tapToFocus;
  final bool showFocusRing;
  final Color? focusRingColor;
  final bool enablePaste;
  final bool enableHaptics;
  final bool readOnly;

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  @override
  State<OtpBubblesInput> createState() => _OtpBubblesInputState();
}

class _OtpBubblesInputState extends State<OtpBubblesInput>
    with SingleTickerProviderStateMixin {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  String _code = '';

  @override
  void initState() {
    super.initState();
    // seed with initial value (digits only, clamped)
    final seed = _onlyDigits(widget.initialValue);
    _code = seed.length > widget.length ? seed.substring(0, widget.length) : seed;
    _ctrl.text = _code;

    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  String _onlyDigits(String s) => s.replaceAll(RegExp(r'[^0-9]'), '');

  List<String?> _toValues(String s) {
    final src = widget.obscure
        ? s.split('').map((_) => widget.obscureChar).toList()
        : s.split('');
    return List<String?>.generate(
      widget.length,
          (i) => i < src.length ? src[i] : null,
    );
  }

  double get _totalWidth =>
      widget.diameter * widget.length + widget.spacing * (widget.length - 1);

  @override
  Widget build(BuildContext context) {
    final canFocus = widget.tapToFocus && !widget.readOnly;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: canFocus ? () => _focus.requestFocus() : null,
      onDoubleTap: () {
        // quick clear
        _setCode('');
      },
      onLongPress: () async {
        if (!widget.enablePaste || widget.readOnly) return;
        final data = await Clipboard.getData(Clipboard.kTextPlain);
        final text = _onlyDigits(data?.text ?? '');
        if (text.isEmpty) return;
        _setCode(text.length > widget.length ? text.substring(0, widget.length) : text);
      },
      child: SizedBox(
        width: _totalWidth,
        height: widget.diameter,
        child: Stack(
          children: [
            // Bubbles
            Center(
              child: OtpBubblesBar(
                values: _toValues(_code),
                diameter: widget.diameter,
                strokeWidth: widget.strokeWidth,
              ),
            ),
            // Optional focus ring on the next slot
            if (widget.showFocusRing && _code.length < widget.length)
              Positioned(
                left: (_code.length) * (widget.diameter + widget.spacing),
                top: 0,
                child: IgnorePointer(
                  child: Container(
                    width: widget.diameter,
                    height: widget.diameter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: (widget.focusRingColor ??
                            widget.borderColor.withOpacity(0.35)),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

            // Invisible TextField (captures input)
            Positioned.fill(
              child: AbsorbPointer(absorbing: widget.readOnly, child: _buildInput()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput() {
    return TextField(
      controller: _ctrl,
      focusNode: _focus,
      autofocus: widget.autoFocus,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(widget.length),
      ],
      // fully hidden caret/text
      cursorColor: Colors.transparent,
      style: const TextStyle(color: Colors.transparent, height: 0.01),
      decoration: const InputDecoration(
        border: InputBorder.none,
        counterText: '',
        contentPadding: EdgeInsets.zero,
      ),
      enableInteractiveSelection: false,
      onChanged: (v) {
        if (widget.enableHaptics) HapticFeedback.selectionClick();
        _setCode(v);
      },
      onSubmitted: (v) {
        if (v.length == widget.length) widget.onCompleted?.call(v);
      },
    );
  }

  void _setCode(String v) {
    final clean = _onlyDigits(v);
    setState(() {
      _code = clean.length > widget.length ? clean.substring(0, widget.length) : clean;
      if (_ctrl.text != _code) {
        // keep controller in sync without recursive loop
        final sel = _ctrl.selection;
        _ctrl.text = _code;
        _ctrl.selection = TextSelection.collapsed(offset: _code.length);
        // restore selection if needed (not critical for hidden style)
        if (sel.baseOffset != _code.length) {
          _ctrl.selection = TextSelection.collapsed(offset: _code.length);
        }
      }
    });
    widget.onChanged?.call(_code);
    if (_code.length == widget.length) widget.onCompleted?.call(_code);
  }
}
class OtpBubblesBar extends StatelessWidget {
  const OtpBubblesBar({
    super.key,
    this.values = const <String?>['4','7',null, null],
    this.diameter = 62,
    this.strokeWidth = 3.5,
    this.spacing = 16,
    this.borderColor = const Color(0xFF505AF9),
    this.textColor = const Color(0xFF3A2E6E),
  });

  final List<String?> values;
  final double diameter;
  final double strokeWidth;
  final double spacing;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < values.length; i++) ...[
          Container(
            width: diameter,
            height: diameter,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: strokeWidth),
            ),
            child: (values[i] == null || values[i]!.isEmpty)
                ? null
                : Text(
              values[i]!,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
          if (i != values.length - 1) SizedBox(width: spacing),
        ],
      ],
    );
  }
}
