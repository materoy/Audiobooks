package com.audiobooks.audiobooks.explore.di

import com.audiobooks.audiobooks.core.data.remote.LibrivoxApi
import com.audiobooks.audiobooks.explore.data.repository.ExploreRepositoryImpl
import com.audiobooks.audiobooks.explore.domain.repository.ExploreRepository
import com.audiobooks.audiobooks.explore.domain.use_case.GetFeed
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

    @Singleton
    @Provides
    fun provideHomeRepository(api: LibrivoxApi): ExploreRepository {
        return ExploreRepositoryImpl(api)
    }
}