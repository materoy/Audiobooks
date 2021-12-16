package com.audiobooks.audiobooks.local_media.util
//
//import android.content.ContentUris
//import android.content.Context
//import android.graphics.Bitmap
//import android.net.Uri
//import android.os.Build
//import android.provider.MediaStore
//import android.util.Size
//import android.widget.Toast
//import java.io.ByteArrayOutputStream
//
//class LocalMediaParser () {
//
//    public operator fun invoke(directory: Uri, context: Context): (List, List){
//        val tracks: ArrayList<Track> = arrayListOf<Track>()
//        val albums: ArrayList<LocalAlbumDto> = arrayListOf<LocalAlbumDto>()
//
//        val collection =
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
//                MediaStore.Audio.Media.getContentUri(
//                    MediaStore.VOLUME_EXTERNAL
//                )
//            } else {
//                MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
//            }
//
//        val projection = arrayOf(
//            MediaStore.Audio.Media._ID,
//            MediaStore.Audio.Media.ALBUM,
//            MediaStore.Audio.Media.ALBUM_ID,
//            MediaStore.Audio.Media.DISPLAY_NAME,
//            MediaStore.Audio.Media.DURATION,
//            MediaStore.Audio.Media.ARTIST,
//            MediaStore.Audio.Media.DISC_NUMBER,
//            MediaStore.Audio.Media.AUTHOR,
//            MediaStore.Audio.Media.GENRE,
//            MediaStore.Audio.Media.NUM_TRACKS,
//            MediaStore.Audio.Media.TITLE,
//            MediaStore.Audio.Media.DISPLAY_NAME,
//            MediaStore.Audio.Media.ARTIST_ID,
//            MediaStore.Audio.Media.BOOKMARK,
//            MediaStore.Audio.Media.VOLUME_NAME,
//            MediaStore.Audio.Media.TRACK,
//            MediaStore.Audio.Media.WRITER,
//        )
//
//        // Shows only audio that is at least 5 minutes long
//        val selection = "${MediaStore.MediaColumns.RELATIVE_PATH} LIKE ?"
//        val selectionArgs = arrayOf(
//            folder.path?.split(":")?.last() + "/"
//        )
//
//        val sortOrder = "${MediaStore.Audio.Media.DISPLAY_NAME} ASC"
//
//        val query = context.applicationContext.contentResolver.query(
//            collection,
//            projection,
//            selection,
//            selectionArgs,
//            sortOrder
//        )
//
//        query?.use { cursor ->
//            val idColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media._ID)
//            val albumColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.ALBUM)
//            val albumIdColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.ALBUM_ID)
//            val nameColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DISPLAY_NAME)
//            val durationColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DURATION)
//            val artistColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.ARTIST)
//            val discNumberColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DISC_NUMBER)
//            val authorColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.AUTHOR)
//            val genreColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.GENRE)
//            val numTracksColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.NUM_TRACKS)
//            val titleColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.TITLE)
//            val displayNameColumn =
//                cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DISPLAY_NAME)
//            val artistIdColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.ARTIST_ID)
//            val bookmarkColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.BOOKMARK)
//            val volumeNameColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.VOLUME_NAME)
//            val trackColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.TRACK)
//            val writerColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.WRITER)
//
//
//            if (cursor.moveToFirst())
//                while (cursor.moveToNext()) {
//                    // Get values of columns for a media
//                    val id = cursor.getLong(idColumn)
//                    val name = cursor.getString(nameColumn)
//                    val contentUri: Uri = ContentUris.withAppendedId(
//                        MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
//                        id
//                    )
//                    val album = cursor.getString(albumColumn)
//                    val albumId = cursor.getLong(albumIdColumn)
//                    val duration = cursor.getString(durationColumn)
//                    val artist = cursor.getString(artistColumn)
//                    val discNumber = cursor.getString(discNumberColumn)
//                    val author = cursor.getString(authorColumn)
//                    val genre = cursor.getString(genreColumn)
//                    val numTracks = cursor.getString(numTracksColumn)
//                    val title = cursor.getString(titleColumn)
//
//                    println(
//                        "Name: $name, album: $album, albumId: $albumId" +
//                                "Duration: $duration" +
//                                "Artist: $artist " +
//                                "Disc number: $discNumber " +
//                                "Author: $author " +
//                                "Genre: $genre  " +
//                                "Num tracks: $numTracks " +
//                                "Title: $title  "
//                    )
//
//                    var albumArtBitmap: Bitmap? = null
//                    var albumArtByteArray : ByteArray? = null
//
//                    try {
//
//                        albumArtBitmap = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
//                            context.applicationContext.contentResolver.loadThumbnail(
//                                contentUri,
//                                Size(400, 300),
//                                null
//                            )
//
//                        } else {
//                            MediaStore.Images.Media.getBitmap(
//                                context.applicationContext.contentResolver,
//                                contentUri
//                            )
//                        }
//
//                    } catch (e: Exception){
//                        println(e)
//                    }
//
//                    if(albumArtBitmap != null) {
//                        val stream  = ByteArrayOutputStream()
//                        albumArtBitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
//                        albumArtByteArray = stream.toByteArray()
//                    }
//
//                    tracks.add(
//                        Track(
//                            album = album,
//                            albumId = albumId,
//                            id = id,
//                        )
//                    )
//
//                    albums.add(
//                        LocalAlbumDto(
//                            albumId = albumId,
//                            title = album,
//                            coverageDuration = 0,
//                            currentTrackIndex = 0,
//                            duration = 0,
//                            albumArt = albumArtByteArray
//                        )
//                    )
//                }
//        }
//
//        Toast.makeText(context, "${tracks.size} media found", Toast.LENGTH_SHORT).show()
//    }
//}