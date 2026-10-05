/// Kategori layout hasil breakpoint dari lebar ruang yang tersedia.
enum LayoutCategory {
  compact,
  medium,
  expanded;

  String get label {
    switch (this) {
      case LayoutCategory.compact:
        return 'Compact';
      case LayoutCategory.medium:
        return 'Medium';
      case LayoutCategory.expanded:
        return 'Expanded';
    }
  }
}

/// Batas lebar compact: phone dan layar kecil.
const double kCompactMaxWidth = 600;

/// Batas lebar medium: large phone sampai tablet kecil.
const double kMediumMaxWidth = 840;

/// Menghitung kategori layout dari lebar yang tersedia.
LayoutCategory layoutCategoryOf(double width) {
  if (width < kCompactMaxWidth) {
    return LayoutCategory.compact;
  }
  if (width < kMediumMaxWidth) {
    return LayoutCategory.medium;
  }
  return LayoutCategory.expanded;
}

/// Jumlah kolom GridView yang sesuai dengan kategori layout.
int gridColumnsFor(LayoutCategory category) {
  switch (category) {
    case LayoutCategory.compact:
      return 1;
    case LayoutCategory.medium:
      return 2;
    case LayoutCategory.expanded:
      return 3;
  }
}