package com.audiobooks.audiobooks.core.di

import com.audiobooks.audiobooks.core.data.remote.LibrivoxApi
import com.google.gson.GsonBuilder
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.components.SingletonComponent
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import javax.inject.Singleton

@Module
@InstallIn(SingletonComponent::class)
object CoreModule {


    @Provides
    @Singleton
    fun provideLibrivoxApi(): LibrivoxApi {
        return Retrofit.Builder()
            .baseUrl(LibrivoxApi.BASE_URL)
            .addConverterFactory(GsonConverterFactory.create(
                GsonBuilder().setLenient().create()
            ))
            .build()
            .create(LibrivoxApi::class.java)
    }
}