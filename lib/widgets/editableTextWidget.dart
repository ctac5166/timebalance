import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timebalance/main.dart';

class EditableTextWidget extends ConsumerStatefulWidget {
  final String initialText;
  final ValueChanged<String> onTextChanged;
  final TextStyle textStyle;

  const EditableTextWidget({
    super.key,
    required this.initialText,
    required this.textStyle,
    required this.onTextChanged,
  });

  @override
  _EditableTextWidgetState createState() => _EditableTextWidgetState();
}

class _EditableTextWidgetState extends ConsumerState<EditableTextWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      _finishEditing();
    }
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
    _focusNode.requestFocus();
  }

  void _finishEditing() {
    setState(() {
      _isEditing = false;
    });
    FocusScope.of(context).unfocus();
    widget.onTextChanged(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _startEditing,
      child: Container(
        // color: Colors.red,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 12,
          ),
          child: _isEditing
              ? IntrinsicWidth(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    maxLength: 28, // Ограничение по количеству символов
                    decoration: const InputDecoration(
                      counterText: "", // Скрыть счетчик символов
                      border: InputBorder.none, // Убрать линию под текстом
                    ),
                    onSubmitted: (_) => _finishEditing(),
                    style: AppThemeModel.infoTextStyle,
                  ),
                )
              : ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: Text(
                    _controller.text.isEmpty
                        ? 'Нажмите Для Редатирования'
                        : _controller.text,
                    style: widget.textStyle,
                  ),
                ),
        ),
      ),
    );
  }
}
