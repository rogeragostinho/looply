import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:looply/viewmodel/import_export_view_model.dart';
import 'package:looply/viewmodel/tag_view_model.dart';
import 'package:looply/viewmodel/topic_view_model.dart';
import 'package:provider/provider.dart';
import 'package:looply/router/app_routes.dart';
import 'package:looply/ui/core/widgets/app_top_bar.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ImportExportViewModel>();
    final isLoading = vm.status == ImportExportStatus.loading;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppTopBar(title: "Preferências"),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          // ── Gestão ───────────────────────────────────────
          _SectionHeader(label: "Gestão"),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.label_outline,
                  label: "Tags",
                  onTap: () => context.push(AppRoutes.tags),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Dados ─────────────────────────────────────────
          _SectionHeader(label: "Dados"),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.upload_file_outlined,
                  label: "Exportar dados",
                  isLoading: isLoading,
                  onTap: isLoading ? null : () => _onExport(context, vm),
                ),
                const Divider(height: 1, indent: 56),
                _SettingsTile(
                  icon: Icons.download_outlined,
                  label: "Importar dados",
                  isLoading: isLoading,
                  onTap: isLoading ? null : () => _onImport(context, vm),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onExport(BuildContext context, ImportExportViewModel vm) async {
    await vm.exportData();
    if (!context.mounted) return;

    if (vm.status == ImportExportStatus.success) {
      _showSnack(context, "Exportado para: ${vm.exportedPath}");
    } else if (vm.status == ImportExportStatus.error) {
      _showError(context, vm.errorMessage);
    }

    vm.reset();
  }

  Future<void> _onImport(BuildContext context, ImportExportViewModel vm) async {
    await vm.importData();
    if (!context.mounted) return;

    if (vm.status == ImportExportStatus.success) {
      await context.read<TagViewModel>().loadTags();
      await context.read<TopicViewModel>().loadTopics();
      _showSnack(context, "Dados importados com sucesso!");
    } else if (vm.status == ImportExportStatus.error) {
      _showError(context, vm.errorMessage);
    }

    vm.reset();
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showError(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? "Ocorreu um erro."),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 0),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.onSurface.withOpacity(0.75)),
      title: Text(label),
      trailing: isLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.primary,
              ),
            )
          : Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface.withOpacity(0.35),
            ),
      onTap: onTap,
    );
  }
}