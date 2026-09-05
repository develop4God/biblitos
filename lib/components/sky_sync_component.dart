import 'package:biblitos/providers/sky_provider.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';

/// Invisible component that forwards [skyProvider] changes to the World via
/// [onSkyChanged]. Listening to a provider from a FlameGame directly isn't
/// supported by flame_riverpod — only a Component's [addToGameWidgetBuild]
/// hook may call `ref.listen` — so this component exists purely to bridge
/// that gap. It reads/reacts only; the World still owns what the sky change
/// actually does (updating its background color).
class SkySyncComponent extends Component with RiverpodComponentMixin {
  SkySyncComponent({required this.onSkyChanged});

  final void Function(bool isNight) onSkyChanged;

  @override
  void onMount() {
    addToGameWidgetBuild(() {
      onSkyChanged(ref.read(skyProvider));
      ref.listen<bool>(skyProvider, (previous, isNight) {
        onSkyChanged(isNight);
      });
    });
    super.onMount();
  }
}
