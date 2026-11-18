import 'dart:async';
import 'dart:math' as math;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:tailwind_breakpoints/tailwind_breakpoints.dart';
import 'package:tarkeez/core/shared_files/bottom_sheet/bottom_sheet_wrapper.dart';
import 'package:tarkeez/core/utils/container_design_utils.dart';
import 'package:tarkeez/core/utils/text_utils.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class UserManualBottomSheet extends StatefulWidget {
  const new({super.key});

  @override
  State<UserManualBottomSheet> createState() => _UserManualBottomSheetState();
}

class _UserManualBottomSheetState extends State<UserManualBottomSheet> {
  YoutubePlayerController? _controller;
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    Connectivity().checkConnectivity().then(_updateStatus);
    _subscription = Connectivity().onConnectivityChanged.listen(_updateStatus);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final online = !results.contains(ConnectivityResult.none);
    if (!mounted || (online == _isOnline && (_controller != null) == online)) {
      return;
    }

    setState(() {
      _isOnline = online;
      if (online) {
        _controller = YoutubePlayerController.fromVideoId(
          autoPlay: true,
          videoId: '1f5ftgJM1dk',
          params: const YoutubePlayerParams(showFullscreenButton: false),
        );
      } else {
        _controller?.close();
        _controller = null;
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BottomSheetWrapper(
      contents: [
        ClipRRect(
          borderRadius: ContainerDesignUtils.allRadius,
          child: ColoredBox(
            color: scheme.surface,
            child: SizedBox(
              width: double.infinity,
              height: !_isOnline
                  ? 100
                  : math.min(context.screenHeight * 0.6, 460),
              child: _controller != null
                  ? YoutubePlayer(controller: _controller!, aspectRatio: 16 / 9)
                  : _isOnline
                  ? const SizedBox.shrink()
                  : Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: scheme.onSurface),
                      child: Text(
                        'No internet connection.\nConnect to the internet to watch the manual video.',
                        textAlign: TextAlign.center,
                        style: TextUtils.paragraph(context),
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
