package com.audiobooks.audiobooks.feature_home.di

import com.audiobooks.audiobooks.core.data.remote.LibrivoxApi
import com.audiobooks.audiobooks.feature_home.data.repository.HomeRepositoryImpl
import com.audiobooks.audiobooks.feature_home.domain.repository.HomeRepository
import com.audiobooks.audiobooks.feature_home.domain.use_case.GetFeed
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton


@Module
@InstallIn(SingletonComponent::class)
object HomeModule {

    @Provides
    @Singleton
    fun provideGetFeedUseCase(repository: HomeRepository): GetFeed {
        return GetFeed(repository)
    }

    @Singleton
    @Provides
    fun provideHomeRepository(api: LibrivoxApi): HomeRepository {
        return HomeRepositoryImpl(api)
    }
}