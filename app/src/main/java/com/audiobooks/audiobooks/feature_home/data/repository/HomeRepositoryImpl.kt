package com.audiobooks.audiobooks.feature_home.data.repository

import com.audiobooks.audiobooks.core.data.remote.LibrivoxApi
import com.audiobooks.audiobooks.core.domain.model.Audiobook
import com.audiobooks.audiobooks.core.util.Resource
import com.audiobooks.audiobooks.feature_home.domain.repository.HomeRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import retrofit2.HttpException
import java.io.IOException

class HomeRepositoryImpl(
    private val api: LibrivoxApi
): HomeRepository {
    override fun getFeed(): Flow<Resource<List<Audiobook>>> = flow {
        emit(Resource.Loading<List<Audiobook>>())

        try {
            val remoteAudiobooks = api.getFeed()
            emit(Resource.Success<List<Audiobook>>(remoteAudiobooks.books.map { it.toAudiobook() }))

        } catch (e: HttpException){
            println(e)
            emit(Resource.Error<List<Audiobook>>(
                "Ooops, something went wrong",
            ))
        } catch (e: IOException) {
            println(e)
            emit(Resource.Error<List<Audiobook>>(
                "Couldn't reach server check your internet connection",
            ))
        }
    }
}