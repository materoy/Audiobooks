package com.audiobooks.audiobooks.core.presentation

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.PersonOutline
import androidx.compose.material.icons.outlined.*
import androidx.compose.material.icons.rounded.Explore
import androidx.compose.material.icons.rounded.Home
import androidx.compose.ui.graphics.vector.ImageVector
import java.lang.IllegalArgumentException

enum class AudiobooksScreen(val icon : ImageVector? = null) {

    Home(icon = Icons.Rounded.Explore),

    Search(icon = Icons.Outlined.Search),

    Library(icon = Icons.Outlined.LocalLibrary),

    Profile(icon = Icons.Default.PersonOutline),
    Snippets,
    Settings,
    Player,
    MediaFolders,
    AudiobookDetail;

    companion object {
        fun fromRoute(route: String?) : AudiobooksScreen =
            when(route?.substringBefore("/")){
                Home.name -> Home
                Search.name -> Search
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