package com.audiobooks.audiobooks.explore.domain.repository

import com.audiobooks.audiobooks.core.domain.model.Audiobook
import com.audiobooks.audiobooks.core.util.Resource
import kotlinx.coroutines.flow.Flow

interface ExploreRepository {

    fun getFeed(): Flow<Resource<List<Audiobook>>>
}