package com.audiobooks.audiobooks.explore.domain.use_case

import com.audiobooks.audiobooks.core.domain.model.Audiobook
import com.audiobooks.audiobooks.core.util.Resource
import com.audiobooks.audiobooks.explore.domain.repository.ExploreRepository
import kotlinx.coroutines.flow.Flow

class GetFeed (
    private val repository: ExploreRepository
        ){

    operator fun invoke(): Flow<Resource<List<Audiobook>>>{
        return repository.getFeed()
    }
}