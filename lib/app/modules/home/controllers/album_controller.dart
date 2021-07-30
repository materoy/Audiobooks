import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/data/models/track.dart';
import 'package:audiobooks/app/modules/home/providers/album_provider.dart';
import 'package:audiobooks/app/modules/home/providers/player_provider.dart';
import 'package:audiobooks/app/modules/home/providers/track_provider.dart';
import 'package:audiobooks/app/modules/library/controllers/library_controller.dart';
import 'package:audiobooks/app/modules/overlay/controllers/overlay_controller.dart';
import 'package:audiobooks/app/modules/shelf/controllers/shelf_controller.dart';
import 'package:audiobooks/app/modules/splash/controllers/splash_controller.dart';
import 'package:audiobooks/app/utils/database.dart';
import 'package:get/get.dart';

class AlbumController extends GetxController {
  AlbumController({required LocalDatabase localDatabase, required this.album})
      : _localDatabase = localDatabase;

  ShelfController get _shelfController => Get.find<ShelfController>();

  StreamSubscription? currentMediaItemStream;

  final LocalDatabase _localDatabase;
  final Album album;
  TrackProvider get _trackProvider => TrackProvider(_localDatabase);
  AlbumProvider get _albumProvider => AlbumProvider(_localDatabase);
  PlayerProvider get _playerProvider => PlayerProvider(_localDatabase);

  final _tracks = List<Track>.empty(growable: true).obs;
  final _mediaItemsQueue = List<MediaItem>.empty(growable: true).obs;
  final _currentTrack = Track.empty().obs;
  final _liked = false.obs;

  final _playing = false.obs;

  List<Track> get tracks => _tracks;
  Track get currentTrack => _currentTrack.value;
  MediaItem get currentMediaItem => getMediaItemFromTrack(currentTrack);
  List<MediaItem> get mediaItemsQueue => _mediaItemsQueue;
  bool get playing => _playing.value;
  bool get liked => _liked.value;

  set currentMediaItem(MediaItem mediaItem) => currentMediaItem = mediaItem;

  /// Queries the database for tracks that contains current album Id
  /// and stores them in tracks
  Future<void> getTracksInAlbum() async {
    await _trackProvider.getTracksInAlbum(album.albumId!).then((value) {
      _tracks.addAll(value);

      for (final Track track in value) {
        final MediaItem mediaItem = getMediaItemFromTrack(track);
        _mediaItemsQueue.add(mediaItem);
      }
    });
  }

  MediaItem getMediaItemFromTrack(Track track) {
    return MediaItem(
      id: track.path!,
      album: track.albumName ?? track.trackName ?? '',
      title: track.trackName ?? track.albumName ?? '',
      artist: track.albumArtistName ?? track.trackArtistNames?.toList().first ?? track.authorName,
    );
  }

  /// Sets the current track in album
  Future<void> updateCurrentTrack(int trackId) async {
    await _albumProvider.updateCurrentTrackInCollection(trackId: trackId, albumId: album.albumId!);

    await _albumProvider.updateCurrentPlayngAlbum(albumId: album.albumId!);
  }

  Future<void> getCurrentTrack() async {
    if (album.currentTrackId != null) {
      final int currentTrackId = await _albumProvider.getCurrentTrackId(album.currentTrackId!);
      if (currentTrackId != 0) {
        _currentTrack.value = await _trackProvider.getTrackById(currentTrackId);
      } else {
        _currentTrack.value = _tracks.first;
      }
    } else {
      _currentTrack.value = _tracks.first;
    }
  }

  Future<int> getCurrentTrackPosition() async {
    return _playerProvider.getCurrentTrackPlayPosition(_currentTrack.value.path!);
  }

  Future<void> goToNextTrack() async {
    await AudioService.skipToNext();
    final int currentIndex =
        _tracks.indexWhere((element) => element.path == AudioServiceBackground.mediaItem!.id);
    final int nextTrackIndex = currentIndex + 1;
    if (_tracks.length > nextTrackIndex) {
      _currentTrack.value = _tracks[nextTrackIndex];
      await updateCurrentTrack(_tracks[nextTrackIndex].trackId!);
    }
  }

  Future<void> goToPreviousTrack() async {
    await AudioService.skipToPrevious();
    final int currentIndex =
        _tracks.indexWhere((element) => element.path == AudioServiceBackground.mediaItem!.id);
    final int previousTrackIndex = currentIndex - 1;
    if (previousTrackIndex >= 0) {
      _currentTrack.value = _tracks[previousTrackIndex];
      await updateCurrentTrack(_tracks[previousTrackIndex].trackId!);
    }
  }

  void showInfoDialog(String message) {
    Get.snackbar('Audiobooks', message);
  }

  Future<void> onPlay() async {
    if (!AudioService.running) {
      await startBackgroundAudioService();
    }
    if (AudioService.playbackState.playing) {
      AudioService.pause();
    }

    await AudioService.updateQueue(mediaItemsQueue);
    await AudioService.updateMediaItem(currentMediaItem);
    await _albumProvider.updateCurrentPlayngAlbum(albumId: album.albumId!);
    await Get.find<OverlayController>().refreshAlbum();
    AudioService.play();
    _playing.value = true;

    if (Get.isRegistered<ShelfController>() &&
        _shelfController.shelf.shelfName == 'Recently added') {
      await _shelfController.moveFromRecentlyAddedToListening(currentAlbumId: album.albumId!);
      await Get.find<LibraryController>().refreshShelves();
    }
  }

  Future<void> onPause() async {
    await AudioService.pause();
    _playing.value = false;
  }

  Future likeAlbum() async {
    await _albumProvider.likeAlbum(album.albumId!);
    _liked.value = true;
  }

  Future unlikeAlbum() async {
    await _albumProvider.unlikeAlbum(album.albumId!);
    _liked.value = false;
  }

  Future checkLiked() async {
    _liked.value = await _albumProvider.checkLiked(album.albumId!);
  }

  late StreamSubscription playBackState;

  @override
  Future onInit() async {
    super.onInit();
    await getTracksInAlbum();
    await getCurrentTrack();

    _playing.value = AudioService.currentMediaItem != null &&
        currentTrack.path == AudioService.currentMediaItem!.id &&
        AudioService.playbackState.playing;
  }

  @override
  Future onReady() async {
    super.onReady();
    await checkLiked();

    /// Listens for changes in playback stream
    ///  updates the playing state of the respective album
    playBackState = AudioService.playbackStateStream.listen((event) {
      _playing.value = AudioService.currentMediaItem != null &&
          currentTrack.path == AudioService.currentMediaItem!.id &&
          AudioService.playbackState.playing;
    });

    /// Listens for changes in current media from the audio service
    /// updates the album table when there is a change in current media
    currentMediaItemStream = AudioService.currentMediaItemStream.listen((event) async {
      if (event != null) {
        if (event.album == album.albumName && event.id != currentTrack.path) {
          final Track newTrack = await _trackProvider.getTrackByPath(event.id);

          /// Update controllers current track
          _currentTrack.value = newTrack;

          /// Update in the database
          await _albumProvider.updateCurrentTrackInCollection(
              trackId: newTrack.trackId!, albumId: album.albumId!);
        }
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    currentMediaItemStream?.cancel();
    playBackState.cancel();
  }
}
