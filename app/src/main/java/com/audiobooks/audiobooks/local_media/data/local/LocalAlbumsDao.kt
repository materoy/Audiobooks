package com.rmgennative.audiobooks.data.local

import androidx.room.*
import com.rmgennative.audiobooks.data.local.dto.LocalAlbumDto
import com.rmgennative.audiobooks.domain.model.Album
import kotlinx.coroutines.flow.Flow

@Dao
interface LocalAlbumsDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(album: LocalAlbumDto)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(albums: List<LocalAlbumDto>)

    @Query("SELECT * FROM albums")
    suspend fun getAll(): List<LocalAlbumDto>

    @Query("SELECT * FROM albums WHERE albumId IN (:albumId)")
    suspend fun getById(albumId: Long): LocalAlbumDto

    @Delete
    suspend fun delete(albums: LocalAlbumDto)
}