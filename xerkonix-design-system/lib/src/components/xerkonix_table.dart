import 'package:flutter/material.dart';

import '../palette/color.dart';
import '../shape/xerkonix_shape.dart';
import '../typography/xerkonix_typography.dart';

class XkTableCell {
  const XkTableCell({
    this.text,
    this.child,
    this.textColor,
    this.textStyle,
    this.textAlign = TextAlign.left,
  }) : assert(text != null || child != null);

  final String? text;
  final Widget? child;
  final Color? textColor;
  final TextStyle? textStyle;
  final TextAlign textAlign;
}

class XkTableRowData {
  const XkTableRowData(this.cells);

  final List<XkTableCell> cells;
}

/// Simple data table component that follows Weave visual defaults.
class XkTable extends StatelessWidget {
  const XkTable({
    super.key,
    required this.columns,
    required this.rows,
    this.borderRadius,
    this.headerBackgroundColor,
    this.rowBackgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    this.columnSpacing = 14,
  });

  final List<String> columns;
  final List<XkTableRowData> rows;
  final BorderRadiusGeometry? borderRadius;
  final Color? headerBackgroundColor;
  final Color? rowBackgroundColor;
  final EdgeInsetsGeometry padding;
  final double columnSpacing;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerBg = headerBackgroundColor ??
        (isDark ? XkColor.darkSurfaceSoft : XkColor.surfaceSoft);
    final rowBg =
        rowBackgroundColor ?? (isDark ? XkColor.darkSurface : XkColor.surface);
    final borderColor = isDark ? XkColor.darkBorderSoft : XkColor.borderSoft;
    final headerText = isDark ? XkColor.darkTextBody : XkColor.textBody;
    final rowText = isDark ? XkColor.darkText : XkColor.text;

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? XkShape.mdBorderRadius,
        border: Border.all(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStatePropertyAll(headerBg),
          dataRowColor: WidgetStatePropertyAll(rowBg),
          horizontalMargin: 0,
          columnSpacing: columnSpacing,
          headingTextStyle: XkTypo.label.copyWith(
            fontSize: 12,
            color: headerText,
          ),
          dataTextStyle: XkTypo.body.copyWith(
            fontSize: 12,
            color: rowText,
          ),
          columns: columns
              .map(
                (column) => DataColumn(
                  label: Padding(
                    padding: padding,
                    child: Text(column),
                  ),
                ),
              )
              .toList(),
          rows: rows
              .map(
                (row) => DataRow(
                  cells: row.cells
                      .map(
                        (cell) => DataCell(
                          Padding(
                            padding: padding,
                            child: cell.child ??
                                Text(
                                  cell.text ?? '',
                                  textAlign: cell.textAlign,
                                  style: cell.textStyle ??
                                      XkTypo.body.copyWith(
                                        fontSize: 12,
                                        color: cell.textColor ?? rowText,
                                      ),
                                ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
