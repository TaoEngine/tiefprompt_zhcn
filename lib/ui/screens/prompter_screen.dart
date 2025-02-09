import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiefprompt/core/theme.dart';
import 'package:tiefprompt/providers/prompter_provider.dart';
import 'package:tiefprompt/providers/settings_provider.dart';
import 'package:tiefprompt/ui/widgets/prompter_bottom_bar.dart';
import 'package:tiefprompt/ui/widgets/prompter_top_bar.dart';
import 'package:tiefprompt/ui/widgets/scrollable_text.dart';
import 'package:tiefprompt/providers/script_provider.dart';

final controlsVisibleProvider = StateProvider<bool>((ref) => true);

class PrompterScreen extends ConsumerStatefulWidget {
  const PrompterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrompterScreenState();
}

class _PrompterScreenState extends ConsumerState<PrompterScreen> {
  @override
  Widget build(BuildContext context) {
    final script = ref.watch(scriptProvider);
    final controlsVisible = ref.watch(controlsVisibleProvider);
    final settings = ref.watch(settingsProvider);
    PrompterState prompter;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    if (!ref.exists(prompterProvider)) {
      settings.whenData((settingsState) {
        ref.read(prompterProvider.notifier).applySettings(settingsState);
      });
    }
    prompter = ref.watch(prompterProvider);

    return Theme(
        data: prompterBlackTheme,
        child: Scaffold(
            body: Stack(fit: StackFit.expand, children: [
          GestureDetector(
            onTap: () {
              ref.read(controlsVisibleProvider.notifier).state =
                  !controlsVisible;
            },
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ScrollableText(
                  text: script.text,
                  style: TextStyle(
                      fontSize: prompter.fontSize,
                      color: Theme.of(context).colorScheme.onPrimary),
                )),
          ),
          if (controlsVisible) PrompterTopBar(),
          if (controlsVisible) PrompterBottomBar(),
        ])));
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }
}
