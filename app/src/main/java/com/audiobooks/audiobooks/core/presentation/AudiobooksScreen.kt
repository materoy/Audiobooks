package com.audiobooks.audiobooks.core.presentation

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material.icons.outlined.*
import androidx.compose.material.icons.rounded.Explore
import androidx.compose.material.icons.rounded.Home
import androidx.compose.material.icons.rounded.PersonOutline
import androidx.compose.ui.graphics.vector.ImageVector
import java.lang.IllegalArgumentException

enum class AudiobooksScreen(val icon : ImageVector? = null) {

    Home(icon = Icons.Outlined.Explore),

    Podcast(icon = Icons.Default.Podcasts),

    Library(icon = Icons.Default.ViewWeek),

    Profile(icon = Icons.Rounded.PersonOutline),
    Snippets,
    Settings,
    Player,
    MediaFolders,
    AudiobookDetail;

    companion object {
        fun fromRoute(route: String?) : AudiobooksScreen =
            when(route?.substringBefore("/")){
                Home.name -> Home
                Podcast.name -> Podcast
                Library.name -> Library
                Snippets.name -> Snippets
                AudiobookDetail.name -> AudiobookDetail
                Player.name -> Player
                Settings.name -> Settings
                Profile.name -> Profile
                MediaFolders.name -> MediaFolders
                null -> Home
                else -> throw  IllegalArgumentException("Route $route is note recognized.")
            }
    }
}