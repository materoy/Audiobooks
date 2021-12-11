package com.audiobooks.audiobooks.feature_home.domain.use_case

import com.audiobooks.audiobooks.core.domain.model.Audiobook
import com.audiobooks.audiobooks.core.util.Resource
import com.audiobooks.audiobooks.feature_home.domain.repository.HomeRepository
import kotlinx.coroutines.flow.Flow

class GetFeed (
    private val repository: HomeRepository
        ){

    operator fun invoke(): Flow<Resource<List<Audiobook>>>{
        return repository.getFeed()
    }
}