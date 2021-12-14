package com.rmgennative.audiobooks.data.local

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import com.audiobooks.audiobooks.local_media.data.local.entity.MediaFolderDto

@Dao
interface MediaFoldersDao {

    @Query("SELECT * FROM MediaFolderDto")
    suspend fun getAll() : List<MediaFolderDto>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(mediaFolder: MediaFolderDto)
}