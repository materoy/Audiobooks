package com.audiobooks.audiobooks.core.data.remote

import com.audiobooks.audiobooks.core.data.remote.dto.LibrivoxAudiobookDto
import com.audiobooks.audiobooks.core.data.remote.dto.LibrivoxAudiobooksDto
import retrofit2.http.GET

interface LibrivoxApi {

    @GET("feed/audiobooks/format/json/")
    suspend fun getFeed(): LibrivoxAudiobooksDto

    companion object {
        const val BASE_URL = "https://librivox.org/api/"
    }
}