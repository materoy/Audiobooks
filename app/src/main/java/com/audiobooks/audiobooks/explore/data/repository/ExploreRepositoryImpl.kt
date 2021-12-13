package com.audiobooks.audiobooks.explore.data.repository

import com.audiobooks.audiobooks.core.data.remote.BookShelvesApi
import com.audiobooks.audiobooks.core.data.remote.LibrivoxApi
import com.audiobooks.audiobooks.core.domain.model.Audiobook
import com.audiobooks.audiobooks.core.util.Resource
import com.audiobooks.audiobooks.explore.domain.repository.ExploreRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import retrofit2.HttpException
import java.io.IOException

class ExploreRepositoryImpl(
    private val api: LibrivoxApi,
    private val shelfApi: BookShelvesApi
): ExploreRepository {
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

    override fun getGenre(genre: String): Flow<Resource<List<Audiobook>>> = flow {
        emit(Resource.Loading<List<Audiobook>>())

        try {
            val remoteAudiobooks = api.getGenre(genre)
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