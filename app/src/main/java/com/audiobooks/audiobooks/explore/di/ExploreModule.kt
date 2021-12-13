package com.audiobooks.audiobooks.explore.di

import com.audiobooks.audiobooks.core.data.remote.BookShelvesApi
import com.audiobooks.audiobooks.core.data.remote.LibrivoxApi
import com.audiobooks.audiobooks.explore.data.repository.ExploreRepositoryImpl
import com.audiobooks.audiobooks.explore.domain.repository.ExploreRepository
import com.audiobooks.audiobooks.explore.domain.use_case.GetFeed
import com.audiobooks.audiobooks.explore.domain.use_case.GetGenre
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton


@Module
@InstallIn(SingletonComponent::class)
object ExploreModule {

    @Provides
    @Singleton
    fun provideGetFeedUseCase(repository: ExploreRepository): GetFeed {
        return GetFeed(repository)
    }

    @Provides
    @Singleton
    fun provideGetGenreUseCase(repository: ExploreRepository): GetGenre {
        return GetGenre(repository)
    }

    @Singleton
    @Provides
    fun provideHomeRepository(api: LibrivoxApi, shelfApi: BookShelvesApi): ExploreRepository {
        return ExploreRepositoryImpl(api, shelfApi)
    }
}