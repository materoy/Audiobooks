package com.audiobooks.audiobooks.feature_home.domain.repository

import com.audiobooks.audiobooks.core.domain.model.Audiobook
import com.audiobooks.audiobooks.core.util.Resource
import kotlinx.coroutines.flow.Flow

interface HomeRepository {

    fun getFeed(): Flow<Resource<List<Audiobook>>>
}