package com.rmgennative.audiobooks.data.local

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import com.rmgennative.audiobooks.data.local.dto.LocalTrackDto

@Dao
interface LocalTracksDao {

    @Insert(onConflict = OnConflictStrategy.ABORT, entity = LocalTrackDto::class)
    suspend fun insertAll(trackDto: List<LocalTrackDto>)

    @Query("SELECT * FROM local_audiobooks WHERE albumId == :albumId")
    suspend fun getAllInAlbum(albumId: Long): List<LocalTrackDto>

    @Query("SELECT * FROM local_audiobooks")
    suspend fun getAllTracks(): List<LocalTrackDto>

}