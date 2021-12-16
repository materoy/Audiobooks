package com.rmgennative.audiobooks.data.local

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import com.rmgennative.audiobooks.data.local.dto.LocalTrackEntity

@Dao
interface LocalTracksDao {

    @Insert(onConflict = OnConflictStrategy.ABORT, entity = LocalTrackEntity::class)
    suspend fun insertAll(trackEntity: List<LocalTrackEntity>)

    @Query("SELECT * FROM local_audiobooks WHERE albumId == :albumId")
    suspend fun getAllInAlbum(albumId: Long): List<LocalTrackEntity>

    @Query("SELECT * FROM local_audiobooks")
    suspend fun getAllTracks(): List<LocalTrackEntity>

}