import 'package:dropdown_button2/dropdown_button2.dart';


import '../../constant/app_imports.dart';

class CustomDropdown<T> extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.valueListenable,
    required this.items,
    required this.label,
    required this.onChanged,
    this.hint = '',
    this.height = 48,
    this.borderRadius = 12,
    this.prefixIcon,
    this.suffixIcon,
    this.leadingIcon,
    this.itemBuilder,
    this.selectedBuilder,
    this.iconBuilder,
    this.colorBuilder,
    this.showBorder = true,
    this.isExpanded = true,
    this.dropdownWidth,
    this.maxDropdownHeight = 250,
    this.backgroundColor,
    this.borderColor,
    this.contentPadding =
    const EdgeInsets.symmetric(horizontal: 12),
  });

  final ValueNotifier<T?> valueListenable;
  final List<T> items;
  final String hint;
  final String Function(T) label;
  final ValueChanged<T?>? onChanged;

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final IconData? leadingIcon;

  final Widget Function(T)? itemBuilder;
  final Widget Function(T)? selectedBuilder;

  final IconData Function(T)? iconBuilder;
  final Color Function(T)? colorBuilder;

  final bool showBorder;
  final bool isExpanded;

  final double height;
  final double borderRadius;
  final double maxDropdownHeight;
  final double? dropdownWidth;

  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = backgroundColor ?? AppColors.bgLight;

    final Color borderClr = borderColor ??
        (showBorder
            ? AppColors.lightDivider
            : Colors.transparent);

    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        valueListenable: valueListenable,
        isExpanded: isExpanded,
        onChanged: onChanged,

        hint: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              const SizedBox(width: 8),
            ] else if (leadingIcon != null) ...[
              Icon(
                leadingIcon,
                size: 18,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                hint,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: FontFamily.regular,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),

        items: items.map((item) {
          final itemColor = colorBuilder?.call(item);
          final itemIcon = iconBuilder?.call(item);

          return DropdownItem<T>(
            value: item,
            child: itemBuilder != null
                ? itemBuilder!(item)
                : Row(
              children: [
                if (itemIcon != null) ...[
                  Icon(
                    itemIcon,
                    size: 18,
                    color: itemColor,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    label(item),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.regular,
                      color: itemColor ??
                          AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),

        selectedItemBuilder: (context) {
          return items.map((item) {
            final itemColor = colorBuilder?.call(item);
            final itemIcon = iconBuilder?.call(item);

            if (selectedBuilder != null) {
              return selectedBuilder!(item);
            }

            return Row(
              children: [
                if (itemIcon != null) ...[
                  Icon(
                    itemIcon,
                    size: 16,
                    color: itemColor,
                  ),
                  const SizedBox(width: 8),
                ] else if (leadingIcon != null) ...[
                  Icon(
                    leadingIcon,
                    size: 16,
                    color: AppColors.primaryPurple,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    label(item),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: FontFamily.regular,
                      color: itemColor ??
                          AppColors.textPrimary,
                    ),
                  ),
                ),
                if (suffixIcon != null) ...[
                  const SizedBox(width: 8),
                  suffixIcon!,
                ],
              ],
            );
          }).toList();
        },

        buttonStyleData: ButtonStyleData(
          height: height,
          width: dropdownWidth,
          padding: contentPadding,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius:
            BorderRadius.circular(borderRadius),
            border: showBorder
                ? Border.all(
              color: borderClr,
              width: 1,
            )
                : null,
          ),
        ),

        iconStyleData:  IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 20,
            color: AppColors.textPrimary,
          ),
        ),

        dropdownStyleData: DropdownStyleData(
          width: dropdownWidth,
          maxHeight: maxDropdownHeight,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: showBorder
                ? Border.all(
              color: borderClr,
              width: 1,
            )
                : null,
          ),
        ),

        menuItemStyleData: MenuItemStyleData(
          overlayColor: WidgetStateProperty.all(
            Colors.black12,
          ),
        ),
      ),
    );
  }
}