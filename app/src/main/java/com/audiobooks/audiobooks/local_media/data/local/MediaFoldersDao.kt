package com.rmgennative.audiobooks.data.local

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import com.rmgennative.audiobooks.data.local.dto.MediaFolderDto

@Dao
interface MediaFoldersDao {

    @Query("SELECT * FROM MediaFolderDto")
    suspend fun getAll() : List<MediaFolderDto>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(mediaFolder: MediaFolderDto)
}