package com.audiobooks.audiobooks.core.presentation

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material.icons.outlined.*
import androidx.compose.material.icons.rounded.Person
import androidx.compose.ui.graphics.vector.ImageVector
import com.audiobooks.audiobooks.R
import java.lang.IllegalArgumentException

enum class AudiobooksScreen(val icon : ImageVector? = null, val resIcon: Int? = null) {

    Explore(icon = Icons.Outlined.Explore),

    Podcast(icon = Icons.Default.Podcasts),

    Library(resIcon = R.drawable.library_icon),

    Profile(icon = Icons.Rounded.Person),

    Snippets,
    Settings,
    Player,
    MediaFolders,
    AudiobookDetail;

    companion object {
        fun fromRoute(route: String?) : AudiobooksScreen =
            when(route?.substringBefore("/")){
                Explore.name -> Explore
                Podcast.name -> Podcast
                Library.name -> Library
                Snippets.name -> Snippets
                AudiobookDetail.name -> AudiobookDetail
                Player.name -> Player
                Settings.name -> Settings
                Profile.name -> Profile
                MediaFolders.name -> MediaFolders
                null -> Explore
                else -> throw  IllegalArgumentException("Route $route is note recognized.")
            }
    }
}